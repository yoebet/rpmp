# -*- encoding : utf-8 -*-

class GoalsController < ProjectResourceController

  def release
    @release=Release.new
    @release.goal=Goal.find(params[:id])
    render 'release_form'
  end
end
