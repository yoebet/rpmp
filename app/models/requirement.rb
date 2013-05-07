# -*- encoding : utf-8 -*-

class Requirement < ActiveRecord::Base
  include ModelSupport
  include ProjectResource
  include FixCounters

  belongs_to :modu, :counter_cache => true
  belongs_to :raised_by, :polymorphic => true
  has_attachments
  has_status
  setup_associations [[:communications]]

  def raised_by_user
    "#{raised_by.class.name}##{raised_by.id}" if raised_by
  end

  def raised_by_user=(user)
    self.raised_by_type,self.raised_by_id=user.split('#')
  end

  protected

  def status_change_action(from_status, to_status)
    if from_status==STATUS_COMPLETED
      'open'
    end
  end

end
