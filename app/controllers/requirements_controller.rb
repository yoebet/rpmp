# -*- encoding : utf-8 -*-

class RequirementsController < ProjectResourceController
  before_filter ({:only => [:index, :uncompleted]}) { @filter=params }

  def uncompleted
    set_resource_collection { |rs| rs.uncompleted }
    render 'index'
  end

  def create
    super { save_yield }
  end

  def update
    super { save_yield }
  end

  protected

  def save_yield
    set_associations 'communication'
  end

end
