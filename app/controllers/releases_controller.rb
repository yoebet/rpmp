# -*- encoding : utf-8 -*-

class ReleasesController < ProjectResourceController

  def create
    super :location_evaluator => lambda { target_location }
  end

  def update
    super :location => target_location
  end

  private

  def target_location
    project_goal_url(@project, resource.goal)
  end

end
