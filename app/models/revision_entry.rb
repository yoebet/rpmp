# -*- encoding : utf-8 -*-

class RevisionEntry < ActiveRecord::Base
  include ModelSupport

  belongs_to_project
  belongs_to :revision, :counter_cache => true
end
