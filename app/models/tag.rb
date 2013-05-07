# -*- encoding : utf-8 -*-

class Tag < ActiveRecord::Base
  include ModelSupport

  belongs_to_project
  belongs_to_user :user
  belongs_to :subject, :polymorphic => true, :counter_cache => true

  def self.statistic(params)
    project_id=params[:project_id]
    project_id=project_id.to_i if project_id

    Task.connection.select_all <<-SQL
      select
        name,
        count(*) TOTAL,
        sum(if(subject_type='Document',1,0)) documents_count,
        sum(if(subject_type='Requirement',1,0)) requirements_count,
        sum(if(subject_type='Issue',1,0)) issues_count,
        sum(if(subject_type='Task',1,0)) tasks_count
      from tags
      #{" where project_id = #{project_id}" if project_id}
      group by name
      order by TOTAL desc
    SQL
  end

end
