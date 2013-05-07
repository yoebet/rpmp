# -*- encoding : utf-8 -*-

class WeekliesController < ProjectResourceController
  before_filter :check_self_or_pm

  def index
    set_filter(:weekly)
    unless @cu.pm?(@project)
      @filter['registrar_id']=@cu.id
    end
    super
  end

  protected

  def check_self_or_pm
    weekly=Weekly.find(params[:id]) if params[:id]
    unless weekly.nil? || weekly.registrar_id==@cu.id || @cu.admin_or_root?
      flash[:err_msg] = '无权限'
      redirect_to project_weeklies_path
    end
  end
end

