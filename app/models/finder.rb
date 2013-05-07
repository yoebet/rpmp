# -*- encoding : utf-8 -*-

module Finder

  def uncompleted
    status Const::STATUS_UNCOMPLETED
  end

  def completed
    status Const::STATUS_COMPLETED
  end

  def status(s)
    where('status = ?', s)
  end

  def my_projects(cu)
    if cu.all_projects_visible?
      scoped
    else
      where('project_id in (?)', (cu.projects.map &:id))
    end
  end

  def personal(cu)
    where('recipient_id' => cu.id)
  end

  def has_tag(name)
    joins(:tags).where('tags.name' => name)
  end

  def counter_gt(name, threshold=0)
    where("#{name}_count > #{threshold.to_i}")
  end

  def range_filter(field, from, to)
    #return scoped unless columns_hash.key?(field)
    if not from.blank? and not to.blank?
      where("#{field} between ? and ?", from, to)
    elsif not from.blank?
      where("#{field} >= ?", from)
    elsif not to.blank?
      where("#{field} <= ?", to)
    else
      scoped
    end
  end

  def range_intersect_filter(field_from, field_to, from, to)
    #return scoped unless columns_hash.key?(field_from) && columns_hash.key?(field_to)
    return scoped if from.nil? && to.nil?
    return where("#{field_from} <= ?", to) if from.nil?
    return where("#{field_to} >= ?", from) if to.nil?
    where("#{field_from} <= ? and #{field_to} >= ?", to, from)
  end

  def eq_filters=(eq_filters)
    @eq_filter_columns=nil
    @eq_filters=eq_filters
  end

  def ge_filters=(ge_filters)
    @ge_filter_columns=nil
    @ge_filters=ge_filters
  end

  def like_filters=(like_filter)
    @like_filter_columns=nil
    @like_filters=like_filter
  end

  class_eval do
    attr_reader :eq_filters, :ge_filters, :like_filters
    attr_accessor :counter_filters
  end

  def default_filter(params)
    sc=scoped
    return sc if params.blank?
    params=params.dup

    @eq_filters||=%w(modu_id registrar_id status)
    @ge_filters||=%w(priority urgency importance)
    @like_filters||=%w(abstract)

    @eq_filter_columns||=columns_hash.values_at(*@eq_filters).compact
    @ge_filter_columns||=columns_hash.values_at(*@ge_filters).compact
    @like_filter_columns||=columns_hash.values_at(*@like_filters).compact
    # %w(comments attachments tags issues)
    @counter_filters||=column_names.grep(/_count$/).map { |w| w.sub(/_count$/, '') }

    sc=setup_scope(sc, params, 'eq', *@eq_filter_columns)
    return sc if params.empty?

    sc=setup_scope(sc, params, 'ge', *@ge_filter_columns)
    return sc if params.empty?

    sc=setup_scope(sc, params, 'like', *@like_filter_columns)
    return sc if params.empty?

    sc=counters_filter(sc, params, *@counter_filters)
    return sc if params.empty?

    if !params['tag'].blank? && reflect_on_association(:tags)
      sc=sc.has_tag(params['tag'])
    end
    sc
  end

  alias_method :filter, :default_filter

  protected :default_filter

  protected

  def setup_scope(sc, params, cmp=nil, *columns)
    columns.inject(sc) do |s, column|
      name=column.name
      value=params.delete name
      if value.blank?
        s
      else
        cmp=params["#{name}_cmp"]||cmp||'eq'
        op={eq: '=', gt: '>', ge: '>=', lt: '<', le: '<=', ne: '<>'}[cmp.to_sym]
        if op
          case column.type
            when :integer, :boolean
              value=value.to_i
            when :float, :decimal
              value=value.to_f
          end
          s.where("#{name} #{op} ?", value)
        else
          case cmp
            when 'like'
              s.where("#{name} like ?", "%#{value}%")
            when 'llike'
              s.where("#{name} like ?", "#{value}%")
            when 'rlike'
              s.where("#{name} like ?", "%#{value}")
            when 'is_null'
              s.where("#{name} is null")
            else
              s
          end
        end
      end
    end
  end

  def counters_filter(sc, params, *names)
    names.inject(sc) do |s, name|
      value=params.delete name
      if value=='1'
        s.counter_gt name
      else
        s
      end
    end
  end
end
