# -*- encoding : utf-8 -*-

class TaskStatisticsController < ProjectResourceController

  def show
    #redirect_to :action => :ranks
    ranks and render 'ranks'
  end

  def ranks
    task_ranks
  end

  def matrix
    task_matrix
  end

end
