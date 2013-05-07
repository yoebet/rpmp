# -*- encoding : utf-8 -*-

class Sys::SessionsController < ApplicationController
  skip_before_filter :authorize, :notify_user

  def create
    user = Sys::User.authenticate(params[:name], params[:password])
    if user
      session[:user_id] = user.id
      if (tryed_url=session[:tryed_url])
        session[:tryed_url]=nil
        redirect_to tryed_url
      else
        redirect_to root_path
      end
    else
      flash.now[:err_msg] = "用户名/密码错误"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to sys_login_path, :notice => "已退出"
  end

end

