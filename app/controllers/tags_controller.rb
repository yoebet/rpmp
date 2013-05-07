# -*- encoding : utf-8 -*-

class TagsController < ProjectResourceController
  actions :ranks
  before_filter :set_tag_name, :except => [:index]

  def index
    @tag_statistic=Tag.statistic :project_id => @project.id
  end

  def show
    find_tags
  end

  def documents
    find_tags :subject_type => 'Document'
    render 'show'
  end

  def requirements
    find_tags :subject_type => 'Requirement'
    render 'show'
  end

  def issues
    find_tags :subject_type => 'Issue'
    render 'show'
  end

  def tasks
    find_tags :subject_type => 'Task'
    render 'show'
  end

  private

  def find_tags(condition={})
    condition[:name]=@name if @name && condition[:name].nil?
    @tags=Tag.where(condition).paginate(:page => params[:page])
  end

  def set_tag_name
    @name=params[:id]
  end

end
