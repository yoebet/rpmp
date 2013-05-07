# -*- encoding : utf-8 -*-

class DepartmentsController < InheritedResources::Base
  defaults :resource_class => Sys::Department
  actions :ranks

  def users
    @department=Sys::Department.find params[:id]
    respond_to do |format|
      format.html
      users=@department.users.collect { |u| {:id => u.id, :name => u.name} }
      format.xml { render :xml => users }
      format.json { render :json => users }
    end
  end

end
