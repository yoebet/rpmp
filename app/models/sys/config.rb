# -*- encoding : utf-8 -*-

class Sys::Config < ActiveRecord::Base
  include ::ModelSupport
  include ::SysLog

  validates :name, :zh_name, :presence => true, :uniqueness => true

  def self.value(name)
    c=find_by_name name
    c.value if c
  end

  def self.configs(prefix)
    Hash[where('name like ?',"#{prefix}%").map {|c|[c.name,c.value]}]
  end

end
