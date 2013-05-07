# -*- encoding : utf-8 -*-

class IssuesController < ProjectResourceController
  custom_actions :resource => [:solve, :regress]

  def index
    find_issues
  end

  def unsolved
    find_issues &:unsolved
  end

  def to_test
    find_issues &:to_test
  end

  def closed
    find_issues &:closed
  end

  def unclosed
    find_issues &:unclosed
  end

  def reopen
    @reopen=true
    @issue=Issue.find(params[:id])
    @issue.status=Const::STATUS_UNSOLVED
    render 'edit'
  end

  def create
    super { save_yield }
  end

  def update
    @issue=Issue.find(params[:id])
    form_source=params[:form_source]
    if form_source=='solve'
      @issue.status=Const::STATUS_TO_TEST if params[:issue_solved]=='1'
      @issue.status=Const::STATUS_UNSOLVED if params[:issue_solved].nil? or params[:issue_solved]=='0'
    end
    if form_source=='regress'
      @issue.status=Const::STATUS_CLOSED if params[:issue_test_passed]=='1'
      @issue.status=Const::STATUS_TO_TEST if params[:issue_test_passed].nil? or params[:issue_test_passed]=='0'
    end
    if @issue.solved_by_id.nil? and (not @issue.cause.blank? or not @issue.solution.blank?)
      @issue.solved_by_id=@cu.id
    end
    if @issue.test_by_id.nil? and not @issue.test_memo.blank?
      @issue.test_by_id=@cu.id
    end
    super { save_yield }
  end

  def associated
    @issue=params[:id] ? Issue.find(params[:id]) : Issue.new
    render '_associated_issues'
  end

  def statistic
    issues_statistic
  end

  protected

  def save_yield
    set_associations 'liable_person', 'user'
    set_associations 'associated_issue', 'issue'
  end

  def find_issues(&block)
    set_filter(:issue)
    @filter.delete 'status' unless action_name=='index'
    set_resource_collection &block
    render 'index'
  end

end
