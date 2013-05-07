# -*- encoding : utf-8 -*-

class Modu < ActiveRecord::Base
  include ModelSupport

  validates :name, :presence => true, :uniqueness => true

  attr_accessor :luu_id

  belongs_to_project
  has_many :requirements
  has_many :issues
  has_many :tasks
  has_many :activities, :as => :subject

  after_create { save_activity :action => 'created' }

  after_update { save_activity :action => 'updated' }

  after_destroy { save_activity :action => 'deleted' }

end
