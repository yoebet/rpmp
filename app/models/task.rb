# -*- encoding : utf-8 -*-

class Task < ActiveRecord::Base
  include ModelSupport
  include ProjectResource
  include FixCounters

  validates :expected_days, :approved_days, :allow_blank => true, :numericality => {:message => '请输入数字'}
  validate :validate_expected_term
  validate :validate_actual_term, :on => :update

  belongs_to_user :recipient
  belongs_to :modu, :counter_cache => true
  has_attachments
  has_status([['未接收', STATUS_UNRECEIVED], ['未完成', STATUS_UNCOMPLETED], ['已完成', STATUS_COMPLETED], ['搁置', 8], ['已撤销', 9]])
  setup_kv('work_rank', [['未评分', STATUS_UNRANKED], ['C', 1], ['B', 2], ['A', 3], ['AA', 4], ['AAA', 5]], 0)
  setup_associations [[:requirements], [:issues]]

  scope :todo, ->() { where('status = ? or status = ?', STATUS_UNRECEIVED, STATUS_UNCOMPLETED) }

  def self.filter(params)
    self.eq_filters||=%w(modu_id registrar_id status recipient_id work_rank)
    sc=default_filter(params)
    sort_by=params['sort_by']
    sc=sc.reorder("#{sort_by} desc") if !sort_by.blank? && columns_hash.key?(sort_by)
    sc
  end

  def ranked?
    self.work_rank!=STATUS_UNRANKED
  end

  def completed?
    self.status==STATUS_COMPLETED
  end

  protected

  def status_change_action(from_status, to_status)
    if from_status==STATUS_UNRECEIVED && to_status==STATUS_UNCOMPLETED
      'received'
    elsif from_status==STATUS_COMPLETED
      'rollback'
    end
  end

  private

  def validate_start_finish_date(start, finish)
    start_date, finish_date=self.send(start), self.send(finish)
    unless start_date.nil?
      if start==:actual_start_on
        errors.add(start, '实际开始日期错误') if start_date.to_datetime > Date.today
        errors.add(finish, '实际完成日期错误') if finish_date.to_datetime > Date.today
      else
        errors.add(start, '开始日期过晚，请检查是否输入错误') if start_date.to_datetime >= 1.year.from_now
      end
      unless finish_date.nil?
        span=(finish_date-start_date).to_i+1
        errors.add(finish, '完成日期早于开始日期') if span < 0
        errors.add(finish, '期限过长') if span > 365
        days_field=(start==:actual_start_on)? :approved_days : :expected_days
        days=self.send(days_field)
        errors.add(days_field, '天数错误') if days && days > span
      end
    end
  end

  def validate_expected_term
    validate_start_finish_date(:expected_start_on, :expected_finish_on)
    validates_presence_of :expected_start_on, :expected_finish_on, :message => '请输入预计期限'
    errors.add(:expected_days, '请输入预计天数') if expected_days.blank?
  end

  def validate_actual_term
    validate_start_finish_date(:actual_start_on, :actual_finish_on)
    status_change=attribute_change('status')
    if status_change && status==STATUS_COMPLETED
      validates_presence_of :actual_start_on, :actual_finish_on, :message => '请输入实际期限'
      errors.add(:approved_days, '请输入实际天数') if approved_days.blank?
    end
  end

end
