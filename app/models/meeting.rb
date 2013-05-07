# -*- encoding : utf-8 -*-

class Meeting < ActiveRecord::Base
  include ModelSupport
  include ProjectResource

  belongs_to_user :emcee
  has_attachments
  setup_associations [[:participants, :user]]
end
