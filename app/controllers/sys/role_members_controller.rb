# -*- encoding : utf-8 -*-

class Sys::RoleMembersController < Sys::ProjectResourcesController
  before_filter :set_role

  def new
    @remain_roles=Sys::Role.all-@project.roles
    if @remain_roles.empty?
      render :js => 'alert("已无角色可增加")'
    else
      render_if_xhr '_new'
    end
  end

  def edit
    render_if_xhr '_edit'
  end

  def show
    render_if_xhr '_show'
  end

  def create
    @role=Sys::Role.find(params[:role_id])
    update_role_member_and_render
  end

  def update
    update_role_member_and_render
  end

  protected

  def set_role
    id=params[:id]
    @role=@project.roles.find(id) if id && id.to_i.nonzero?
  end

  def update_role_member_and_render
    pmrs=Sys::ProjMemberRole.where('project_id = ? and role_id = ?', @project.id, @role.id)
    o_user_ids=pmrs.map &:user_id
    user_ids=(params[:user_ids]||[]).map &:to_i
    return if o_user_ids==user_ids
    pmrs.each do |pmr|
      unless user_ids.include? pmr.user_id
        set_luu(pmr)
        pmr.destroy
      end
    end
    (user_ids-o_user_ids).each do |user_id|
      pmr=Sys::ProjMemberRole.new({:project => @project, :role => @role, :user_id => user_id})
      set_luu(pmr)
      pmr.save
    end

    @role=Sys::Role.find(@role.id)
    uip=@role.users_in_project(@project)
    if uip.size.zero?
      render :js => "$('#role_#{@role.id}').remove()"
    else
      render_if_xhr '_show'
    end
  end

  def render_if_xhr(file)
    render file, :layout => false, :locals => {:role => @role} if request.xhr?
  end

end
