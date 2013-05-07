# -*- encoding : utf-8 -*-

class Test < ActiveRecord::Base
  include ModelSupport
  include ProjectResource

  belongs_to_user :head
  belongs_to :release
  has_many :issues, :dependent => :destroy
  has_attachments
  has_status([['进行中', 0], ['未通过', 1], ['完成', 3], ['通过', 5], ['已撤销', 9]])
  setup_associations [[:participants, :user], [:requirements], [:modus]]
end
