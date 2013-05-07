# -*- encoding : utf-8 -*-

class Association < ActiveRecord::Base
  include ModelSupport

  belongs_to :subject, :polymorphic => true
  belongs_to :target, :polymorphic => true

  def self.belongs_to_subject(sym, options={})
    o={:foreign_key => 'subject_id', :conditions => "subject_type = '#{sym.to_s.classify}'"}
    belongs_to sym, o.merge!(options)
  end

  def self.belongs_to_target(sym, options={})
    o={:foreign_key => 'target_id', :conditions => "target_type = '#{sym.to_s.classify}'"}
    belongs_to sym, o.merge!(options)
  end

  belongs_to_subject :task

  belongs_to_target :user, :class_name => 'Sys::User'
  belongs_to_target :modu
  belongs_to_target :communication
  belongs_to_target :issue
  belongs_to_target :requirement
end
