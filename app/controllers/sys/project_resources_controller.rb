# -*- encoding : utf-8 -*-

class Sys::ProjectResourcesController < Sys::AdminController
  before_filter :set_project

  protected

  def set_project
    @project = Sys::Project.find(params[:project_id])
  end

end
