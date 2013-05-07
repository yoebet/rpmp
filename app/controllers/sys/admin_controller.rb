# -*- encoding : utf-8 -*-

class Sys::AdminController < InheritedResources::Base
  respond_to :html, :json, :js, :xml
  before_filter :check_sysrole

  def facet
    render '/sys/index'
  end

  private

  def check_sysrole
    unless @cu.admin_or_root?
      flash[:err_msg] = '没有权限'
      redirect_to root_path
    end
  end

  def require_root
    unless @cu.root?
      flash[:err_msg] = '没有权限'
      if @cu.admin?
        redirect_to sys_admin_root_path
      else
        redirect_to root_path
      end
    end
  end

  def set_luu(model=get_resource_ivar)
    model.luu_id=@cu.id if model.respond_to?(:luu_id)
    model.luu_ip=request.remote_ip if model.respond_to?(:luu_ip)
  end

  def create_resource(object)
    set_luu(object)
    object.save
  end

  def update_resource(object, attributes)
    set_luu(object)
    object.update_attributes(*attributes)
  end

  def destroy_resource(object)
    set_luu(object)
    object.destroy
  end

  def sys_log(atts={})
    log=Sys::Log.new({user_id: @cu.id, user_ip: request.remote_ip}.merge(atts))
    log.save
  end

end
