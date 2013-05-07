# -*- encoding : utf-8 -*-

class Sys::PersonalController < ApplicationController
  skip_before_filter :notify_user

  def update

    up=params[:sys_user]
    ori_password=up[:ori_password]

    unless ori_password.blank?
      new_password=up[:password]
      if new_password == ori_password
        flash.now[:err_msg] = '密码未修改！'
        render 'edit' and return
      end
      puts ori_password
      if Sys::User.encrypted_password(ori_password, @cu.salt) != @cu.hashed_password
        flash.now[:err_msg] = '原密码错误！'
        render 'edit' and return
      end
      @cu.password=new_password
      @cu.password_must_update=false
    end

    @cu.email=up[:email]
    @cu.phone=up[:phone]

    @cu.luu_id=@cu.id
    @cu.luu_ip=request.remote_ip

    unless @cu.save
      render 'edit' and return
    end
    flash[:notice] = '修改成功'
    redirect_to personal_path
  end

end
