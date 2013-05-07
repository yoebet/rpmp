# -*- encoding : utf-8 -*-

class Customer < ActiveRecord::Base
  include ModelSupport
  include ProjectResource

  validates :name, :presence => true
end
