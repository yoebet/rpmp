# -*- encoding : utf-8 -*-

class ProjectsController < ProjectBaseController
  before_filter :set_project, :project_authorize

  def index
    @projects = @cu.visible_projects
    @more=!(@projects.reject! { |p| p.inactive? }.nil?)
  end

  def all
    @projects = @cu.visible_projects
    render 'index'
  end

  def inactive
    @projects = @cu.visible_projects.where(inactive: true)
    render 'index'
  end

  def activities
    @filter=params[:subject_type].nil? ? {} : params
    @activities=projects_resources(Activity)
    render 'activities/index'
  end

  def weeklies
    set_filter(:weekly, 'weekend')
    unless @cu.admin_or_root?
      @filter['registrar_id']=@cu.id
    end
    @weeklies=projects_resources(Weekly)
    render 'weeklies/index'
  end

  def issues
    set_filter(:issue)
    @issues=find_issues
    render 'issues/index'
  end

  def issues_unsolved
    @issues=Issue.unsolved
    issues
  end

  def issues_to_test
    @issues=Issue.to_test
    issues
  end

  def issues_closed
    @issues=Issue.closed
    issues
  end

  def issues_unclosed
    @issues=Issue.unclosed
    issues
  end

  def tasks
    set_filter(:task)
    @tasks=find_tasks
    render 'tasks/index'
  end

  def tasks_todo
    @tasks=Task.todo
    tasks
  end

  def my_tasks
    set_filter(:task)
    @filter.delete 'recipient_id'
    @tasks=find_tasks { |tasks| tasks.personal(@cu) }
    render 'tasks/index'
  end

  def my_tasks_todo
    @tasks=Task.todo
    my_tasks
  end

  def task_ranks
    super
    render 'task_statistics/ranks'
  end

  def task_matrix
    super
    render 'task_statistics/matrix'
  end

  def issues_statistic
    super
    render 'issues/statistic'
  end

  def members
    respond_to do |format|
      format.html
      users=@project.users.collect { |u| {:id => u.id, :name => u.name} }
      format.xml { render :xml => users }
      format.json { render :json => users }
    end
  end

  protected

  def find_tasks
    tasks=@tasks||Task
    tasks=yield tasks if block_given?
    projects_resources(tasks)
  end

  def find_issues
    @filter.delete 'status' unless action_name=='issues'
    issues=@issues||Issue
    issues=yield issues if block_given?
    projects_resources(issues)
  end

  def projects_resources(rmc)
    rmc=rmc.filter(@filter) if !@filter.blank? && rmc.respond_to?(:filter)
    rmc.my_projects(@cu).paginate(:page => params[:page])
  end

  def set_project
    do_set_project :id
  end

end
