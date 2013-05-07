# -*- encoding : utf-8 -*-

class ApplicationController < ActionController::Base
  before_filter :set_user, :authorize, :notify_user
  protect_from_forgery
  require_dependency 'extensions'

  helper :all
  layout :if_layout

  WillPaginate.per_page = 12

  protected

  def set_user
    @cu=Sys::User.find(session[:user_id]) if session[:user_id] rescue nil
    session[:user_id]=nil if @cu.nil?
  end

  def authorize
    unless @cu
      session[:tryed_url]=request.url
      redirect_to sys_login_path
    end
  end

  def notify_user
    if @cu && @cu.password_must_update?
      flash[:err_msg] = "请修改密码"
      redirect_to personal_edit_path
    end
  end

  private

  def if_layout
    request.xhr? ? false : 'application'
  end

end
