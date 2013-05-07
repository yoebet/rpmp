# -*- encoding : utf-8 -*-

class MyTasksController < TasksController

  defaults :resource_class => Task, :collection_name => 'tasks', :instance_name => 'task'

  protected

  def find_tasks(&block)
    set_filter(:task)
    @filter.delete 'recipient_id'
    @tasks=@project.tasks.personal(@cu)
    set_resource_collection &block
  end
end
