# -*- encoding : utf-8 -*-

class Goal < ActiveRecord::Base
  include ModelSupport
  include ProjectResource

  has_status
  setup_kv('version_type', [['内部测试', 1], ['客户测试', 2], ['问题修复', 3], ['正式版本', 4]], 1)

  has_many :releases, :dependent => :destroy
end
