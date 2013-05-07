# -*- encoding : utf-8 -*-

class Comment < ActiveRecord::Base
  include ModelSupport

  belongs_to_project
  belongs_to_user
  belongs_to :subject, :polymorphic => true, :counter_cache => true

  validates :content, :presence => true

  after_create do
    save_activity :action => 'commented', :subject_type => self.subject_type,
                  :subject_id => self.subject_id, :user_id => self.user_id
  end

end
