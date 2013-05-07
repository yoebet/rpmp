# -*- encoding : utf-8 -*-

class Sys::Department < ActiveRecord::Base
  include ::ModelSupport
  include ::SysLog

  validates :name, :presence => true, :uniqueness => true

  has_many :users

  default_scope :order => 's_order'

end
