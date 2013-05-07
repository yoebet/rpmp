# -*- encoding : utf-8 -*-

require 'digest/sha1'
class Sys::User < ActiveRecord::Base
  include ::ModelSupport
  include ::SysLog

  belongs_to :department
  has_many :proj_member_roles
  has_many :roles, :through => :proj_member_roles, :uniq => true
  has_many :projects, :through => :proj_member_roles, :uniq => true
  has_many :message_receives, :class_name => 'MessageReceive', :order => 'id desc', :foreign_key => 'receiver_id'
  has_many :sent_messages, :class_name => 'Message', :order => 'id desc', :foreign_key => 'sender_id'

  default_scope where(:enabled => true) #.order('s_order')

  scope :in_department, where('department_id is not null')

  attr_protected :sysrole
  validates :name, :presence => true, :uniqueness => true
  validates :password, :presence => true, :on => :create
  validates :password, :confirmation => { :message => '两次输入的密码不一致' }, :allow_blank => :true
  validate :validate_password_simplicity

  def visible_projects
    if self.all_projects_visible?
      Sys::Project.scoped
    else
      self.projects
    end
  end

  def all_projects_visible?
    self.admin_or_root? || self.manager?
  end

  def roles_in_project(project)
    roles.where('project_id = ?', project.id)
  end

  def self.authenticate(name, password)
    user = self.find_by_name_and_enabled(name, true)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    self.salt = self.object_id.to_s + rand.to_s
    self.hashed_password = Sys::User.encrypted_password(self.password, self.salt)
  end

  def pm?(project)
    admin_or_root? || roles_in_project(project).find { |r| r.name=='项目经理' or r.name=='项目副经理' }
  end

  def self.password_too_simple?(pass)
    return true if pass.size < 4
    # 1111
    return true if pass =~ /^(\w)\1+$/
    chars=pass.chars.to_a
    # 1212
    return true if chars.uniq.count < 3
    # 1234
    return true if chars.each_cons(2).all? {|a,b|a.succ==b}
    false
  end

  protected

  def validate_password_simplicity
    return if password.blank?
    errors.add('密码', '过于简单') if Sys::User.password_too_simple?(password)
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + '.' + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  private

   def bit_set?(int,b)
     return false if int.nil?
     v = 1 << b
     int & v == v
   end

   def set_bit(int,b,y=true)
     int ||= 0
     v = 1 << b
     if y
       int |= v
     else
       int &= ~v
     end
     int
   end

  def self.define_system_role(name, bit)
    self.class_eval <<-MD, __FILE__, __LINE__ + 1
      def #{name}?
        bit_set? self.sysrole, #{bit}
      end

      alias_method :#{name}, :#{name}?

      def was_#{name}?
        bit_set? self.sysrole_was, #{bit}
      end

      alias_method :was_#{name}, :was_#{name}?

      def set_#{name}(y=true)
        self.sysrole=set_bit(self.sysrole, #{bit}, y)
      end

      def self.#{name}_users
        # FIXME: database dialect dependent
        where("sysrole & #{1 << bit} = #{1 << bit}")
      end
    MD
  end

  #define_system_role 'human_user', 0

  define_system_role 'manager', 1

  define_system_role 'admin', 2

  define_system_role 'root', 3
  
  def admin_or_root?
    self.admin? || self.root?
  end
  
  public :admin_or_root?

  def log_abstract(action)
    if action=='created' || action=='deleted'
      if self.admin?
        return "#{self.name}（系统管理员）"
      else
        return self.name
      end
    end
    if changed_attributes['enabled']
      if !self.enabled_was && self.enabled?
        return "#{self.name}（启用）"
      end
      if self.enabled_was && !self.enabled?
        return "#{self.name}（停用）"
      end
    end
    if changed_attributes['sysrole']
      if !self.was_root? && self.root?
        return "#{self.name}（设为root）"
      end
      if self.was_root? && !self.root?
        return "#{self.name}（取消root）"
      end
      if !self.was_admin? && self.admin?
        return "#{self.name}（设为系统管理员）"
      end
      if self.was_admin? && !self.admin?
        return "#{self.name}（取消系统管理员）"
      end
      if !self.was_manager? && self.manager?
        return "#{self.name}（设为可见所有项目）"
      end
      if self.was_manager? && !self.manager?
        return "#{self.name}（取消可见所有项目）"
      end
    end
    unless self.password.blank?
      return "#{self.name}（修改密码）"
    end
    self.name
  end

end
