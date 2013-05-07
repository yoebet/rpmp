# -*- encoding : utf-8 -*-

class Sys::AnnouncementsController < Sys::AdminController
  custom_actions :resource => :issue

  def index
    @announcements=Sys::Announcement.paginate(:page => params[:page])
  end

  def create
    build_resource.post_by=@cu
    create!
  end

  def issue
    resource
    Sys::Announcement.currents.where('id <> ?', resource.id).update_all :current => false
    resource.current=true
    resource.status=Const::STATUS_ISSUED
    set_luu
    resource.save
    Sys::User.update_all :announcement_notify => true
    flash[:notice] = "公告 #{resource.title} 已发布"
    redirect_to collection_path
  end

  def update
    resource.assign_attributes params[resource_request_name]
    if resource.current?
      Sys::Announcement.currents.where('id <> ?', resource.id).update_all :current => false
    end
    update!
  end

end
