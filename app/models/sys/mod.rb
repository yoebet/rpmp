# -*- encoding : utf-8 -*-

class Sys::Mod < ActiveRecord::Base
  include ::ModelSupport
  include ::SysLog

  validates :code, :name, :presence => true, :uniqueness => true

  default_scope :order => 's_order'
end
