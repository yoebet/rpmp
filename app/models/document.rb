# -*- encoding : utf-8 -*-

class Document < ActiveRecord::Base
  include ModelSupport
  include ProjectResource

  has_attachments
  has_status([['草稿', 1], ['正式', 3], ['作废', 9]])
  setup_associations [[:authors, :user]]
end
