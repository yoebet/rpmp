# -*- encoding : utf-8 -*-

class Communication < ActiveRecord::Base
  include ModelSupport
  include ProjectResource

  belongs_to :customer
  has_attachments
  setup_kv('communicate_type', [['现场', 1], ['电话', 2], ['邮件', 3], ['其他', 4]], 1)
end
