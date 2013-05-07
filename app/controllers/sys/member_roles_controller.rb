# -*- encoding : utf-8 -*-

class Sys::MemberRolesController < Sys::ProjectResourcesController
  before_filter :set_member

  def new
    @remain_users=Sys::User.all-@project.users
    if @remain_users.empty?
      render :js => 'alert("已无用户可增加")'
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
    @user=Sys::User.find(params[:user_id])
    update_member_role_and_render
  end

  def update
    update_member_role_and_render
  end

  protected

  def set_member
    id=params[:id]
    @user=@project.users.find(id) if id && id.to_i.nonzero?
  end

  def update_member_role_and_render
    pmrs=Sys::ProjMemberRole.where('project_id = ? and user_id = ?', @project.id, @user.id)
    o_role_ids=pmrs.map &:role_id
    role_ids=(params[:role_ids]||[]).map &:to_i
    return if o_role_ids==role_ids
    pmrs.each do |pmr|
      unless role_ids.include? pmr.role_id
        set_luu(pmr)
        pmr.destroy
      end
    end
    (role_ids-o_role_ids).each do |role_id|
      pmr=Sys::ProjMemberRole.new({:project => @project, :user => @user, :role_id => role_id})
      set_luu(pmr)
      pmr.save
    end

    @user=Sys::User.find(@user.id)
    rip=@user.roles_in_project(@project)
    if rip.empty?
      render :js => "$('#user_#{@user.id}').remove()"
    else
      render_if_xhr '_show'
    end
  end

  def render_if_xhr(file)
    render file, :layout => false, :locals => {:user => @user} if request.xhr?
  end

end
