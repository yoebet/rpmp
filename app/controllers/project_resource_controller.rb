# -*- encoding : utf-8 -*-

class ProjectResourceController < ProjectBaseController
  before_filter :set_project, :project_authorize
  before_filter :alter_check, :only => [:update, :destroy]
  belongs_to :project

  def index
    set_resource_collection
  end

  def create(options={}, &block)
    set_resource_ivar(model_class.new(params[singular_name])) unless get_resource_ivar
    resource.project_id=@project.id
    resource.registrar_id=@cu.id if resource.respond_to? :registrar_id
    save_prep options, &block
    create! options
  end

  def update(options={}, &block)
    unless get_resource_ivar
      set_resource_ivar(model_class.find(params[:id]))
      resource.assign_attributes params[singular_name]
    end
    save_prep options, &block
    update! options
  end

  def destroy
    resource.luu_id=@cu.id if resource.respond_to? :luu_id
    if request.xhr?
      destroy! do |format|
        format.js { render :js => "$('#r_#{params[:id]}').fadeOut(1000,function(){$(this).remove()})" }
      end
    else
      destroy!
    end
  end

  def pm_confirm
    if @cu.pm?(@project)
      m=model_class.find(params[:id])
      m.update_column('confirmed', true)
      render :js => '$("#confirmed").text("是")'
    else
      render :js => 'alert("无权限！")'
    end
  end

  def history
    @activities=@project.activities.where(:subject_type => model_class.name,
                                          :subject_id => params[:id]).reorder('id asc')
    render 'activities/resource_history'
  end

  protected

  def set_project
    do_set_project :project_id
  end

  def model_class
    end_of_association_chain
  end

  def set_resource_collection
    coll=get_collection_ivar||@project.send(resource_collection_name)
    coll=yield coll if block_given?
    coll=coll.filter(@filter) if !@filter.blank? && coll.respond_to?(:filter)
    coll=coll.paginate(:page => params[:page])
    set_collection_ivar(coll)
  end

  def singular_name
    model_class.name.underscore.sub('/', '_')
  end

  def alter_check
    pass=true
    m=model_class.find(params[:id])
    if m.respond_to? :confirmed and m.confirmed
      pass=false unless @cu.pm?(@project)
    end
    unless pass
      if request.xhr?
        render :js => 'alert("已经确认，不能再变更！")'
      else
        raise '已经确认，不能再变更！'
      end
    end
  end

  def set_attachments
    return unless params[:attachments]
    return unless resource.respond_to?(:attachments)
    params[:attachments].each do |at|
      at[:project_id]=@project.id
      attachment=Attachment.new(at)
      attachment.presenter_id=@cu.id
      if attachment.name
        if attachment.tag.nil?
          attachment.tag=resource.new_record? ? 'original' : ''
        end
        resource.attachments << attachment
      end
    end
  end

  def set_associations(name_singular, target_singular=name_singular)
    target_ids=params[:"#{name_singular}_ids"]
    return if target_ids.nil?
    target_ids||=[]
    target_ids.map! { |id| id.to_i }
    target_type=target_singular.to_s.classify
    assoc=resource.associations.where('target_type=?', target_type)
    assoc_ids=assoc.map &:target_id
    return if target_ids==assoc_ids
    to_delete, to_add=assoc_ids-target_ids, target_ids-assoc_ids
    assoc.each do |a|
      a.delete if to_delete.include? a.target_id
    end
    to_add.each do |target_id|
      a=Association.new :project_id => @project.id, :target_type => target_type, :target_id => target_id
      resource.associations << a
    end
    counter_name=:"#{target_singular.pluralize}_count"
    resource.send(:"#{counter_name}=", target_ids.count) if resource.respond_to? counter_name
  end

  def save_tags
    return unless params[:tags]
    return unless resource.respond_to? :tags
    tags=params[:tags].split(' ')
    return if tags==(resource.tags.map &:name)
    resource.tags.delete_all
    tags.each do |name|
      resource.tags << Tag.new(:project_id => @project.id, :user_id => @cu.id, :name => name)
    end
  end

  private

  def save_prep(options)
    resource.luu_id=@cu.id if resource.respond_to? :luu_id
    save_tags
    set_attachments
    yield if block_given?
    location_evaluator=options.delete(:location_evaluator)
    if location_evaluator && location_evaluator.respond_to?(:call)
      options[:location]=location_evaluator.call()
    end
  end

end
