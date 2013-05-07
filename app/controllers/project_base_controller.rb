# -*- encoding : utf-8 -*-

class ProjectBaseController < InheritedResources::Base
  respond_to :html, :json, :js, :xml

  protected

  def project_authorize
    return unless @project
    unless @cu.all_projects_visible? || @cu.projects.include?(@project)
      flash[:err_msg] = '无权限'
      redirect_to projects_path
    end
  end

  def set_filter(name, test_by='abstract')
    #if params.key?(test_by) || params.key?('modu_id') || params.key?('tag')
    #  session[:"#{name}_filter"]=@filter=params
    #else
    #  @filter=session[:"#{name}_filter"]||{}
    #end
    @filter=params.reject { |k,v| v.blank? }
    @filter.except! :controller,:action,:project_id,:page,:utf8,:commit
  end

  def task_ranks_params(params, start_day=1)
    pat='%Y-%-m-%-d'
    if params[:year]
      unless params[:month]
        params[:date_from]="#{params[:year]}-1-1"
        params[:date_to]="#{params[:year]}-12-31"
        return
      end
      params[:date_from]="#{params[:year]}-#{params[:month]}-1"
      df=Date.parse params[:date_from]
      dt=(df >> 1).prev_day
      params[:date_to]=dt.strftime(pat)
    elsif params[:date_from].nil? && params[:date_to].nil?
      df=(Date.current << 1).change :day => start_day
      dt=(df >> 1).prev_day
      params[:date_from]=df.strftime(pat)
      params[:date_to]=dt.strftime(pat)
      params[:year]=df.year
      params[:month]=df.month
    end
  end

  def task_ranks

    task_ranks_params(params)
    date_from,date_to,project_id=Task.date_range_and_project_id(params)

    @rank_weight={C:0.0,B:0.5,A:1.0,AA:1.5,AAA:2.0}
    rw=Sys::Config.value('task.rank_weight')
    if rw
      values=rw.split(',').map &:to_f
      @rank_weight=Hash[[:C,:B,:A,:AA,:AAA].zip(values)]
    end

    # prepared statements no MySQL support yet
    @member_tasks=Task.connection.select_all <<-SQL
      select
        recipient_id,
        su.name recipient_name,
        count(distinct project_id) projects_count,
        count(*) tasks_count,
        sum(expected_days) expected_days,
        sum(approved_days) approved_days,
        sum(if(work_rank=0,1,0)) UN_RANK,
        sum(if(work_rank=1,1,0)) RANK_C,
        sum(if(work_rank=2,1,0)) RANK_B,
        sum(if(work_rank=3,1,0)) RANK_A,
        sum(if(work_rank=4,1,0)) RANK_AA,
        sum(if(work_rank=5,1,0)) RANK_AAA,
        sum(case work_rank
          when 1 then #{@rank_weight[:C]||0}
          when 2 then #{@rank_weight[:B]||0}
          when 3 then #{@rank_weight[:A]||0}
          when 4 then #{@rank_weight[:AA]||0}
          when 5 then #{@rank_weight[:AAA]||0}
          else 0.0 end * approved_days)
          /sum(if(work_rank=0,0,approved_days)) AVG_SCORE
      from tasks
        join sys_users su on recipient_id=su.id and su.enabled=1
      where status=3
        and long_term=0
        #{" and actual_start_on >= '#{date_from}'" unless date_from.blank?}
        #{" and actual_finish_on <= '#{date_to}'" unless date_to.blank?}
        #{" and project_id = #{project_id}" if project_id}
      group by recipient_id
    SQL
  end

  def task_matrix_params(params, max_months=1)
    pat='%Y-%-m-%-d'
    if params[:date_from].blank?
      @matrix_date_from=Date.current-7
      params[:date_from]=@matrix_date_from.strftime(pat)
    else
      @matrix_date_from=Date.parse params[:date_from]
    end
    @matrix_date_to=(@matrix_date_from >> max_months).prev_day
    params[:date_to]=@matrix_date_to.strftime(pat)
  end

  def task_matrix
    task_term=params[:task_term]
    task_term='expected' unless %w(expected actual).include?(task_term)
    field_start_on,field_finish_on="#{task_term}_start_on","#{task_term}_finish_on"
    days_field=(task_term=='expected')? 'expected_days':'approved_days'

    task_matrix_params(params)
    date_from,date_to,project_id=Task.date_range_and_project_id(params)
    @tasks=Task.unscoped.select [:id,:project_id,:abstract,:recipient_id,
      field_start_on.to_sym,field_finish_on.to_sym,days_field.to_sym]
    @tasks=@tasks.range_intersect_filter(field_start_on,field_finish_on,date_from,date_to)
    @tasks=@tasks.where('status != ? and status != ?',Const::STATUS_SUSPEND,Const::STATUS_CANCELED)
    @tasks=@tasks.where(:long_term=>0)
    @tasks=@tasks.where(:project_id=>project_id) if project_id

    member_tasks_map=Hash.new do |map,recipient|
      df=Hash.new {|h,k|h[k]=[]}
      map[recipient]=df
    end

    @furtherest_date=@matrix_date_from
    @tasks.each do |task|
      start_on,finish_on=task.send(field_start_on.to_sym),task.send(field_finish_on.to_sym)
      next if start_on.nil? || finish_on.nil?

      start_on=@matrix_date_from if (@matrix_date_from - start_on).to_i > 5
      finish_on=@matrix_date_to if (finish_on - @matrix_date_to).to_i > 5
      @furtherest_date=finish_on if @furtherest_date < finish_on

      date_to_tasks=member_tasks_map[task.recipient]
      days=task.send(days_field.to_sym).to_i
      days=1 if days==0
      days_diff=(finish_on-start_on).to_i+1 - days
      finish_on.step(start_on,-1) do |date|
        if days_diff > 0 && date.wday%6==0
          days_diff-=1 and next
        end
        date_to_tasks[date] << task
      end
    end
    @member_tasks=member_tasks_map.sort_by {|entry| entry.first}
  end

  def issues_statistic_params(params)
    if params[:date_from].nil? and params[:date_to].nil?
      df=Date.current << 3
      pat='%Y-%-m-%-d'
      params[:date_from]=df.strftime(pat)
    end
  end

  def issues_statistic

    issues_statistic_params(params)

    if @project
      query=@project.issues.unscoped
    else
      query=Issue.unscoped
    end

    counters_map=Hash.new do |map, member|
      map[member]=Hash.new { |m, k| m[k]=0 }
    end

    [%w(raised_by raised created_at),
     %w(registrar registered created_at),
     %w(solved_by solved solved_at),
     %w(closed_by closed created_at)].each do |user_prop, key, date_field|
      user_id_field="#{user_prop}_id"
      fields="#{user_id_field}, count(*) counter"
      fields << ' ,raised_by_type' if user_id_field=='raised_by_id'

      query=query.select(fields)
      .range_filter(date_field, params[:date_from], params[:date_to])
      .where("#{user_id_field} is not null")
      if user_id_field=='raised_by_id'
        query=query.where(raised_by_type: Sys::User.name)
      elsif user_id_field=='solved_by_id'
        query=query.where('status=? or status=?', Const::STATUS_SOLVED, Const::STATUS_CLOSED)
      elsif user_id_field=='closed_by_id'
        query=query.status(Const::STATUS_CLOSED)
      end
      query.group(user_id_field).each do |record|
        user_id=record[user_id_field]
        user=record.send user_prop.to_sym
        next unless user
        member_counters=counters_map[[user_id,user.name]]
        member_counters[key]+=record['counter']||0
      end
    end

    @member_issue_counters=counters_map.sort_by { |entry| entry.first }
  end

  def do_set_project(param_name)
    id_or_code=params[param_name]
    if id_or_code
      if id_or_code =~ /^\d+$/
        @project=Sys::Project.find(id_or_code)
      else
        @project=Sys::Project.find_by_code(id_or_code)
      end
    else
      @project=nil
    end
  end

end
