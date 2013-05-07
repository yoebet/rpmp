# -*- encoding : utf-8 -*-

class Activity < ActiveRecord::Base
  include ModelSupport
  extend Finder

  belongs_to_project
  belongs_to_user
  belongs_to :subject, :polymorphic => true

  default_scope :order => 'id desc'

  ACTION_COMBINED_MAP={'release:created' => '发布', 'weekly:created' => '提交', 'customer:created' => '增加',
                       'modu:created' => '增加'}
  ACTION_MAP={'created' => '创建', 'updated' => '修改', 'deleted' => '删除', 'confirmed' => '确认', 'received' => '接收',
              'completed' => '完成', 'solved' => '解决', 'passed' => '通过', 'ranked' => '评分', 'commented' => '评论',
              'canceled' => '撤销', 'suspended' => '搁置', 'resumed' => '恢复', 'rollback' => '回退', 'closed' => '关闭',
              'opened' => '打开'}

  STATUS_ACTION_MAP={STATUS_COMPLETED => 'completed', STATUS_SOLVED => 'solved', STATUS_PASSED => 'passed',
                     STATUS_SUSPEND => 'suspended', STATUS_CANCELED => 'canceled'}

  FILTER_ACTION_MAP=ACTION_MAP.invert
  FILTER_SUBJECT_MAP={'文档' => Document.name, '需求' => Requirement.name, '任务' => Task.name,
                      '问题' => Issue.name, '周报' => Weekly.name}

  def self.filter(params)
    self.eq_filters||=%w(user_id action subject_type)
    if params[:activity_action]
      params=params.dup
      params[:action]=params.delete :activity_action
    end
    default_filter(params)
  end

  def self.per_page
    15
  end

end
