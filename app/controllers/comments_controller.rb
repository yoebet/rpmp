# -*- encoding : utf-8 -*-

class CommentsController < ProjectResourceController
  actions :all, :except => [:show, :edit]

  def create
    @comment=Comment.new(params['comment'])
    @comment.project_id=@project.id
    @comment.user_id=@cu.id
    success=@comment.save
    if success
      render '_comment', :layout => false, :locals => {:comment => @comment}
    else
      render :nothing => true
    end
  end
end
