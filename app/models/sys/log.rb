# -*- encoding : utf-8 -*-

class Sys::Log < ActiveRecord::Base
  include ::ModelSupport

  belongs_to_user
  belongs_to :subject, :polymorphic => true

  default_scope :order => 'id desc'

  ACTION_MAP={'created' => '创建了', 'updated' => '修改了', 'deleted' => '删除了'}

  SUBJECT_MAP={'Sys::Announcement' => '公告', 'Sys::Config' => '配置', 'Sys::Department' => '部门',
                    'Sys::Mod' => '模块', 'Sys::User' => '用户', 'Sys::Role' => '角色', 'Sys::Project' => '项目',
                    'Sys::ProjMod' => '项目模块', 'Sys::ProjMemberRole' => '项目成员角色'}

  def self.per_page
    15
  end

  public :save_sys_log

end
