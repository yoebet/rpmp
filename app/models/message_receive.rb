# -*- encoding : utf-8 -*-

class MessageReceive < ActiveRecord::Base
  include ModelSupport

  belongs_to :message, :counter_cache => true
  belongs_to_user :receiver

  scope :un_read, ->() { where(:read => false) }

end
