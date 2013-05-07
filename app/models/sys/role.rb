# -*- encoding : utf-8 -*-

class Sys::Role < ActiveRecord::Base
  include ::ModelSupport
  include ::SysLog

  has_many :proj_member_roles
  has_many :users, :through => :proj_member_roles, :uniq => true

  validates :name, :presence => true, :uniqueness => true

  default_scope :order => 's_order'

  def users_in_project(project)
    users.where('project_id = ?', project.id)
  end

end
