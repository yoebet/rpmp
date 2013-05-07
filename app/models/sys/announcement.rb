# -*- encoding : utf-8 -*-

class Sys::Announcement < ActiveRecord::Base
  include ::ModelSupport
  include ::SysLog

  validates :title, :content, :presence => true

  belongs_to_user :post_by
  has_many :announcement_reads, :order => 'created_at'

  setup_kv('status', [['未发布', STATUS_UNISSUED], ['已发布', STATUS_ISSUED], ['已撤销', STATUS_CANCELED]], STATUS_UNISSUED)

  after_initialize ->() { self.content_format='plain' unless self.content_format }

  default_scope :order => 'id DESC'

  scope :currents, ->() { where('current = ?', true) }

  scope :issued, ->() { where('status = ?', STATUS_ISSUED) }

  scope :un_expired, ->() { where('expire_on is null or expire_on > ?', Time.zone.now) }

  def self.issued_un_expired
    issued.un_expired
  end

  private

  def log_abstract(action)
    if action=='created' || action=='deleted'
      return self.title
    end
    if changed_attributes['status']
      if status_was==STATUS_UNISSUED && status==STATUS_ISSUED
        return "#{self.title} （发布）"
      end
      if status_was==STATUS_ISSUED && status==STATUS_UNISSUED
        return "#{self.title} （取消发布）"
      end
      if status==STATUS_CANCELED
        return "#{self.title} （撤销）"
      end
      if status_was==STATUS_CANCELED
        if status==STATUS_ISSUED
          return "#{self.title} （恢复发布）"
        end
        return "#{self.title} （恢复）"
      end
    end
    self.title
  end

end
