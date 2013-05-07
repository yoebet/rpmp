# -*- encoding : utf-8 -*-

class Revision < ActiveRecord::Base
  include ModelSupport

  belongs_to_project
  has_many :revision_entries, :dependent => :destroy
  default_scope :order => 'id desc'

  ACTION_MAP={'A' => '创建', 'M' => '修改', 'D' => '删除'}

  def self.filter(params)
    sc=scoped
    return sc if params.blank?

    author,revision_no=params['author'],params['revision_no']
    sc=sc.where('author = ?', author) unless author.blank?
    unless revision_no.blank?
      revision_no=revision_no.sub(/^r/, '')
      sc=sc.where('revision_no = ?', revision_no) unless revision_no.blank?
    end

    cc,path=params['commit_comment'],params['path']
    sc=sc.where('commit_comment like ?', "%#{cc}%") unless cc.blank?
    unless path.blank?
      sc=sc.joins(:revision_entries).where('revision_entries.path' => path)
      path_action=params['path_action']
      sc=sc.where('revision_entries.action' => path_action) unless path_action.blank?
    end
    sc
  end

  def self.commit_statistic(params)
    date_from,date_to,project_id=date_range_and_project_id(params)

    Task.connection.select_all <<-SQL
      select
        author scm_name,
        su.name rpmp_name,
        count(*) commit_count,
        sum(revision_entries_count) entries_count,
        sum(revision_entries_count)/count(*) avg_entries
      from revisions
      left join sys_users su on author=su.scm_username
      where
        project_id = #{project_id}
        #{" and commit_at >= '#{date_from}'" unless date_from.blank?}
        #{" and commit_at <= '#{date_to}'" unless date_to.blank?}
      group by author
      order by commit_count desc
    SQL
  end

end
