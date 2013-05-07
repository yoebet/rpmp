# -*- encoding : utf-8 -*-

class TasksController < ProjectResourceController

  def new
    @task=Task.new
    set_new_task_issue
  end

  def index
    @tasks=find_tasks
  end

  def todo
    @tasks=find_tasks do |tasks|
      @filter.delete 'status'
      tasks.todo
    end
    render 'index'
  end

  def create
    flash[:created] = true
    super { save_yield }
  end

  def update
    @task=Task.find(params[:id])
    recipient=@task.recipient
    unless (recipient && recipient.id==@cu.id) || @cu.pm?(@project)
      flash[:err_msg] = "不是任务接收人！"
      redirect_to project_tasks_path(@project)
      return
    end
    unless @cu.pm?(@project)
      if @task.confirmed?
        flash[:err_msg] = "任务已不允许修改！"
        redirect_to project_tasks_path(@project)
        return
      end
      params.except! :recipient_id,:priority,:abstract,:content,:modu_id,:expected_start_on,
                     :expected_finish_on,:expected_days,:long_term,:memo,:registrar_id,:work_rank
    end
    super { save_yield }
  end

  def receive
    @task=Task.find(params[:id])
    if @task.recipient.id==@cu.id or @cu.pm?(@project)
      @task.status=Const::STATUS_UNCOMPLETED
      @task.comprehension=params[:task][:comprehension]
      @task.luu_id=@cu.id
      @task.save!
    else
      flash[:err_msg] = "不是任务接收人！"
    end
    redirect_to collection_path
  end

  def rank
    @task=Task.find(params[:id])
    if @cu.pm?(@project)
      task_params=params[:task]
      @task.confirmed=true
      @task.work_rank=task_params[:work_rank]
      @task.rank_memo=task_params[:rank_memo]
      @task.luu_id=@cu.id
      @task.save!
    end
    render '_rank', :layout => false
  end

  def requirements
    @task=params[:id] ? Task.find(params[:id]) : Task.new
    render '_associated_requirements'
  end

  def issues
    @task=params[:id] ? Task.find(params[:id]) : Task.new
    render '_associated_issues'
  end

  protected

  def find_tasks(&block)
    set_filter(:task)
    set_resource_collection &block
  end

  def save_yield
    set_associations 'requirement'
    set_associations 'issue'
  end

  private

  def set_new_task_issue

    return unless @task.new_record?

    issue_id=params[:issue_id]
    return unless issue_id

    issue=Issue.find(issue_id)
    if issue && issue.project_id==@project.id
      @task.issues << issue
      @task.issues_count=1
      @task.abstract="=> #{issue.abstract}"
      @task.content="解决问题: #{issue.abstract}"
    end
  end

end

