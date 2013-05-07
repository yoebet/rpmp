# -*- encoding : utf-8 -*-

class Sys::ProjMemberRole < ActiveRecord::Base
  include ::ModelSupport
  include ::SysLog

  belongs_to_project
  belongs_to_user
  belongs_to :role

  private

  def log_abstract(action)
    "#{project.code}: #{user.name} -> #{role.name}"
  end

end
