# -*- encoding : utf-8 -*-

#require 'mini_magick'
class Attachment < ActiveRecord::Base
  include ModelSupport

  belongs_to_project
  belongs_to_user :presenter
  belongs_to :subject, :polymorphic => true, :counter_cache => true

  SELECT_FIELDS=column_names.delete_if { |e| e=='content' }.join(',')

  attr_accessor :luu_id

  after_create do
    save_activity :action => 'add_attachment',
                  :user_id => self.presenter_id,
                  :subject_type => self.subject_type,
                  :subject_id => self.subject_id
  end

  after_destroy do
    save_activity :action => 'del_attachment',
                  :subject_type => self.subject_type,
                  :subject_id => self.subject_id
  end

  def uploaded_attachment=(af)
    self.name = File.basename(af.original_filename)
    self.content_type = af.content_type.chomp
    self.content_size = af.size
    self.content = af.read
    if self.content_type=~/^image\//
      self.image=true
      self.image_width, self.image_height=0, 0
      #begin
      #  img=MiniMagick::Image.read(self.content)
      #  self.image_width,self.image_height=img["width"],img["height"]
      #rescue # Exception => e
      #end
    end
  end

end
