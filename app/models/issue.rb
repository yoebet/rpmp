# -*- encoding : utf-8 -*-

class Issue < ActiveRecord::Base
  include ModelSupport
  include ProjectResource
  include FixCounters

  belongs_to :modu, :counter_cache => true
  belongs_to :test, :counter_cache => true
  belongs_to :release
  belongs_to :raised_by, :polymorphic => true
  belongs_to_user :solved_by
  belongs_to_user :test_by
  belongs_to_user :closed_by
  setup_associations [[:liable_people, :user], [:associated_issues, :issue]]

  has_attachments
  has_status([['未解决', 1], ['待测试', 2], ['已关闭', 3], ['搁置', 8], ['已撤销', 9]])

  setup_kv(:issue_type, [['程序错误', 1], ['性能问题', 2], ['界面问题', 3], ['交互问题', 5], ['其他问题', 4]], 1)

  has_many :reverse_associations, class_name: 'Association', as: :target
  has_many :task_associations, class_name: 'Association', as: :target, conditions: "subject_type = 'Task'"
  has_many :assigned_tasks, through: :reverse_associations, source: :task

  before_update :set_attrs

  scope :unsolved, ->() { uncompleted }
  scope :to_test, ->() { status(STATUS_TO_TEST) }
  scope :closed, ->() { completed }
  scope :unclosed, ->() { where('status = ? or status = ?', STATUS_UNSOLVED, STATUS_TO_TEST) }

  def self.filter(params)
    self.eq_filters||=%w(modu_id registrar_id status issue_type test_id)
    default_filter(params)
  end

  def unsolved?
    self.status==1
  end

  def to_test?
    self.status==2
  end

  def unclosed?
    self.status==1 or self.status==2
  end

  def solved?
    self.status==2 or self.status==3
  end

  def closed?
    self.status==3
  end

  def raised_by_user
    "#{raised_by.class.name}##{raised_by.id}" if raised_by
  end

  def raised_by_user=(user)
    self.raised_by_type,self.raised_by_id=user.split('#')
  end

  protected

  def set_attrs
    return unless self.status_changed?
    status0,status1=self.status_was,self.status
    if status0==STATUS_UNSOLVED and status1==STATUS_TO_TEST
      self.solved_by_id=self.luu_id
      self.solved_at=Time.now
    elsif status0==STATUS_TO_TEST and status1==STATUS_UNSOLVED
      self.solved_at=nil
    elsif status0!=STATUS_CLOSED and status1==STATUS_CLOSED
      self.closed_by_id=self.luu_id
      self.closed_at=Time.now
    elsif status0==STATUS_CLOSED and status1!=STATUS_CLOSED
      self.closed_at=nil
    end
  end

  def status_change_action(from_status, to_status)
    if to_status==STATUS_COMPLETED
      'closed'
    elsif from_status==STATUS_CLOSED
      'opened'
    elsif from_status==STATUS_SOLVED and to_status==STATUS_UNSOLVED
      'rollback'
    end
  end

end
