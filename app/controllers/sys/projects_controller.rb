# -*- encoding : utf-8 -*-

class Sys::ProjectsController < Sys::AdminController

  def index
    @projects = Sys::Project.where('inactive is null or inactive = 0')
  end

  def all
    @projects = Sys::Project.all
    render 'index'
  end

  def inactive
    @projects = Sys::Project.where(inactive: true)
    render 'index'
  end

  def create
    @project = Sys::Project.new(params[:sys_project])
    update_proj_mods
    create!
  end

  def update
    @project = Sys::Project.find(params[:id])
    update_proj_mods
    update!
  end

  def destroy
    flash[:err_msg] = "不允许删除项目！"
    redirect_to collection_path
  end

  private

  def update_proj_mods
  
    pms=@project.proj_mods
    o_mod_ids=pms.map &:mod_id
    mod_ids=(params[:proj_mod_ids]||[]).map &:to_i
    return if o_mod_ids==mod_ids
    pms.each do |pm|
      unless mod_ids.include? pm.mod_id
        set_luu(pm)
        pm.destroy
      end
    end
    (mod_ids-o_mod_ids).each do |mod_id|
      pm=Sys::ProjMod.new({:project => @project, :mod_id => mod_id})
      set_luu(pm)
      pm.save
    end
  end

end
