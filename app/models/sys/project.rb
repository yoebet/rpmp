# -*- encoding : utf-8 -*-

class Sys::Project < ActiveRecord::Base
  include ::ModelSupport
  include ::SysLog

  validates :code, :name, :presence => true, :uniqueness => true

  has_many :proj_mods
  has_many :mods, :through => :proj_mods, :order => 's_order'
  has_many :proj_member_roles
  has_many :users, :through => :proj_member_roles, :uniq => true, :include => :roles
  has_many :roles, :through => :proj_member_roles, :uniq => true, :include => :users, :order => 's_order'

  has_many :attachments, :select => Attachment::SELECT_FIELDS
  has_many :comments
  has_many :documents
  has_many :meetings
  has_many :customers
  has_many :communications
  has_many :requirements
  has_many :goals
  has_many :releases
  has_many :tests
  has_many :issues
  has_many :tasks
  has_many :weeklies
  has_many :tags
  has_many :activities
  has_many :revisions
  has_many :modus

  def scm_project_base(wlan=false)
    return self.scm if self.scm[%r{^http://}]
    base=scm_repos_root(wlan)
    base+self.scm.gsub(/^\/|\/$/, '')
  end

  def scm_project_repos(wlan=false)
    return self.scm if self.scm[%r{^http://}]
    base=scm_repos_root(wlan)
    base+self.scm[/\w+/]
  end

  protected

  def scm_repos_root(wlan=false)
    base=Sys::Config.value(wlan ? 'scm.base.wlan' : 'scm.base')
    base.ends_with?('/') ? base : "#{base}/"
  end

  private

  def log_abstract(action)
    "#{code}: #{name}"
  end

end
