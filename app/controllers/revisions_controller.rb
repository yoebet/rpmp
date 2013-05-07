# -*- encoding : utf-8 -*-

class RevisionsController < ProjectResourceController
  actions :only => [:ranks, :entries]
  require 'time'
  require 'rexml/document'
  include REXML

  def index
    if !@cu.admin_or_root? && @cu.scm_username.blank?
      flash[:err_msg] = '没有权限'
      redirect_to projects_path
      return
    end

    check_and_update_revisions unless params[:page]

    @filter=params[:path].nil? ? {} : params
    session[:revision_filter_path]=params[:path]
    @filter['path_action']='' if @filter['path'].blank?
    @revisions=@project.revisions.filter(@filter).paginate(:page => params[:page])
  end

  def entries
    @filter_path=session[:revision_filter_path]
    @revision=Revision.find(params[:id])
    @entries=@revision.revision_entries
    render '_entries'
  end

  def source
    return unless set_revision_entry
    source_text=`svn cat -r #{@revision.revision_no} #{@project.scm_project_repos()}#{@revision_entry.path}`
    render :text => source_text
  end

  def diff
    return unless set_revision_entry
    diff_with, rno=params[:diff_with], @revision.revision_no
    diff_with=rno-1 if diff_with.blank?
    diff_text=`svn diff -r #{diff_with}:#{rno} #{@project.scm_project_repos()}#{@revision_entry.path}`
    render :text => diff_text
  end

  def statistic
    if params[:date_from].nil? && params[:date_to].nil?
      df=Date.current << 1
      params[:date_from]=df.strftime('%Y-%-m-%-d')
    end
     @member_commits=Revision.commit_statistic(params)
  end

  private

  def set_revision_entry
    @revision_entry=RevisionEntry.find(params[:entry_id]) rescue nil
    unless @revision_entry
      render :text => 'entry not found.'
      return false
    end
    @revision=Revision.find(@revision_entry.revision_id) rescue nil
    unless @revision and @revision.project_id==@project.id
      render :text => 'revision not found.'
      return false
    end
    true
  end

  def check_and_update_revisions
    last_revision=@project.revisions.order('revision_no desc').first
    if last_revision.nil? or last_revision.created_at < 1.minutes.ago
      new_last_revision=fetch_last_revision
      if new_last_revision
        last_rno=last_revision ? last_revision.revision_no : -1
        if last_rno < new_last_revision.revision_no
          update_revisions last_rno+1
        end
      end
    end
  rescue Exception => e
    puts e
  end

  def code_base
    @project.scm_project_base()
  end

  def fetch_last_revision
    svn_log=`svn --xml -l 1 log #{code_base}`
    xml=Document.new(svn_log)
    revisions=parse_revisions(xml)
    revisions[0] if revisions.length>0
  end

  def update_revisions(from_revision)
    svn_log=`svn --xml -v -r #{from_revision}:HEAD log #{code_base}`
    xml=Document.new(svn_log)
    revisions=parse_revisions(xml)
    revisions.each do |revision|
      revision.save
    end
  end

  def parse_revisions(xml)
    revisions=[]
    xml.root.each_element do |entry|
      revision=Revision.new
      revision.project=@project
      revision.revision_no=entry.attribute('revision').value.to_i
      revision.author=entry.get_elements('author')[0].text
      revision.commit_at=Time.parse(entry.get_elements('date')[0].text).localtime()
      revision.commit_comment=entry.get_elements('msg')[0].text
      paths=entry.get_elements('paths')
      if paths.length > 0
        parse_entries(revision, paths[0])
        revision.revision_entries.sort_by! &:path
      end
      revisions << revision
    end
    revisions
  end

  def parse_entries(revision, paths_node)
    paths_node.each_element do |path|
      entry=RevisionEntry.new
      entry.project=@project
      entry.kind=path.attribute('kind').value
      entry.action=path.attribute('action').value
      entry.path=path.text
      revision.revision_entries << entry
    end
  end

end
