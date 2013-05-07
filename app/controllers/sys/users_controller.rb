# -*- encoding : utf-8 -*-

class Sys::UsersController < Sys::AdminController
  actions :all, :except => [:show]
  before_filter :check_perm, :only => [:update,:destroy]

  def all
    @users=Sys::User.unscoped.all
    render 'index'
  end

  def disabled
    @users=Sys::User.unscoped.where(:enabled => false)
    render 'index'
  end

  def new
    @user=Sys::User.new :password_must_update => true
  end

  def create
    su=params[:sys_user]
    admin,manager=su.delete(:admin)=='1',su.delete(:manager)=='1'
    @user=Sys::User.new(su)
    @user.set_admin if admin
    @user.set_manager if manager
    create!
  end

  def update
    su=params[:sys_user]
    admin,manager,root=su.delete(:admin),su.delete(:manager),su.delete(:root)

    if @user.id==@cu.id && admin=='0'
      if Sys::User.admin_users.count==1
        flash.now[:err_msg] = '你是最后一个系统管理员了！'
        render 'edit' and return
      end
    end

    if @cu.root? && @user.id==@cu.id && root=='0'
      if Sys::User.root_users.count==1
        flash.now[:err_msg] = '你是最后一个超级管理员了！'
        render 'edit' and return
      end
    end

    @user.assign_attributes(su)

    @user.set_admin admin=='1' unless admin.nil?
    @user.set_manager manager=='1' unless manager.nil?
    @user.set_root root=='1' unless !@cu.root? || root.nil?

    set_luu

    render 'edit' and return unless @user.save

    flash[:notice] = "用户 #{@user.name} 已修改."
    redirect_to sys_users_path
  end

  protected

  def resource
    @user||=Sys::User.unscoped.find(params[:id])
  end

  def check_perm
    resource
    if @user.root? && !@cu.root?
      flash.now[:err_msg] = '不能修改root用户！'
      render 'edit'
    end
  end

end

