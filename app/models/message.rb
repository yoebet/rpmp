# -*- encoding : utf-8 -*-

class Message < ActiveRecord::Base
  include ModelSupport

  belongs_to_user :sender
  belongs_to :replied_message, :class_name => 'Message', :counter_cache => 'reply_messages_count'
  has_many :reply_messages, :class_name => 'Message', :foreign_key => :replied_message_id
  has_many :message_receives, :class_name => 'MessageReceive', :dependent => :destroy

end
