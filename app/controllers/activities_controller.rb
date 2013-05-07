# -*- encoding : utf-8 -*-

class ActivitiesController < ProjectResourceController
  actions :only => [:index]

  def index
    set_filter(:activity)
    @activities=@project.activities.filter(@filter).paginate(:page => params[:page])
  end
end
