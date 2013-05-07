# -*- encoding : utf-8 -*-

class AnnouncementsController < InheritedResources::Base
  actions :ranks, :show

  def index
    @announcements=visible.paginate(:page => params[:page])
  end

  def current
    @announcement=visible.currents.first()
    show
    render 'show'
  end

  def show
    @announcement||=visible.find params[:id] if params[:id]
    if @announcement
      ass=@announcement.announcement_reads
      ar=ass.find_by_user_id @cu.id
      if ar
        #ar.touch
      else
        ass.create :user => @cu
      end
    end
    if @cu.announcement_notify?
      @cu.announcement_notify=false
      @cu.update_column :announcement_notify, false
    end
  end

  protected

  def visible
    Sys::Announcement.issued_un_expired
  end
end
