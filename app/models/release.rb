# -*- encoding : utf-8 -*-

class Release < ActiveRecord::Base
  include ModelSupport
  include ProjectResource

  has_attachments
  belongs_to :goal, :counter_cache => true
  has_many :tests, :dependent => :destroy
  has_many :issues, :dependent => :destroy
  default_scope.clear
  default_scope :order => 'id'

end
