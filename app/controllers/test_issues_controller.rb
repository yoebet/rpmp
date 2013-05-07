# -*- encoding : utf-8 -*-

class TestIssuesController < IssuesController
  before_filter :set_test
  belongs_to :test

  defaults :resource_class => Issue, :collection_name => 'issues', :instance_name => 'issue',
           :route_instance_name => 'issue', :route_collection_name => 'issues'

  def index
    @issues=@test.issues
    find_issues
  end

  def unsolved
    @issues=@test.issues.unsolved
    find_issues
  end

  def to_test
    @issues=@test.issues.to_test
    find_issues
  end

  protected

  def set_test
    @test=Test.find(params[:test_id])
  end

end
