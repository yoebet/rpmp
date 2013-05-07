# -*- encoding : utf-8 -*-

class Sys::LogsController < Sys::AdminController
  actions :only => [:show]

  def show
    @logs=Sys::Log.paginate(:page => params[:page])
  end
end
