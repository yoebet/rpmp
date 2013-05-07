# -*- encoding : utf-8 -*-

class Sys::AnnouncementRead < ActiveRecord::Base
  include ::ModelSupport

  belongs_to :announcement
  belongs_to_user :user

end
