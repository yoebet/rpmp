# -*- encoding : utf-8 -*-

class Sys::DumpsController < Sys::AdminController
  before_filter :set_dump_dir
  before_filter :set_dump_file, :only => [:download,:destroy]

  def index
    @dump_files=[]
    unless @dump_dir
      flash.now[:err_msg]=flash.discard :err_msg
      return
    end

    Dir.new(@dump_dir).each do |name|
      next if name=='.' || name=='..'
      full_name="#{@dump_dir}/#{name}"
      next unless File.file?(full_name)
      @dump_files << [name,File.new(full_name)]
    end
    @dump_files.sort! {|f1,f2| f2.last.mtime <=> f1.last.mtime }
  end

  def create
    unless @dump_dir
      redirect_to collection_path
      return
    end
    ignore_attachments=params[:ia]
    dc = Rails.configuration.database_configuration[Rails.env]
    map = {H: dc['host'], D: dc['database'], U: dc['username'], P: dc['password'], DIR: @dump_dir}
    script_config_name=(ignore_attachments=='1')? 'db_dump.script.ia' : 'db_dump.script'
    script=Sys::Config.value(script_config_name)
    unless script
      flash[:err_msg]="备份脚本配置 #{script_config_name} 不存在"
      redirect_to collection_path
      return
    end
    script=script.gsub(/\<(\w+)\>/) { |_| map[$1.to_sym] }
    `#{script}`

    sys_log action: '创建了', abstract: "备份（脚本：#{script_config_name}）"

    redirect_to collection_path
  end

  # download dump file
  def download
    unless @dump_file
      redirect_to collection_path
      return
    end
    o = {:filename => @file_name, :disposition => 'attachment'}
    #send_data @dump_file.read, o
    send_file @full_name, o

    sys_log action: '下载了', abstract: "备份 #{@file_name}"
  end

  def destroy
    unless @dump_file
      redirect_to collection_path
      return
    end
    File.delete @full_name
    flash[:notice]="文件 #{@file_name} 已删除"

    sys_log action: 'deleted', abstract: "备份 #{@file_name}"

    redirect_to collection_path
  end

  def check_key(file)
    # simple check
    (file.size & (1 << 10)-1) ^ 0b01_1010_1010
  end

  private

  def set_dump_dir
    config_name='db_dump.diretory'
    dir=Sys::Config.value(config_name)
    if dir.nil?
      flash[:err_msg]="备份目录配置 #{config_name} 不存在"
      return
    end

    @dump_dir=File.expand_path dir
    unless File.directory?(@dump_dir)
      flash[:err_msg]="目录 #{@dump_dir} 不存在！"
      @dump_dir=nil
    end
  end

  def set_dump_file
    return if @dump_dir.nil?
    name=params[:name]
    return if name.nil?
    @file_name=name.gsub(/\//,'').gsub(/\.{2,}/, '.')
    @full_name="#{@dump_dir}/#{@file_name}"
    unless File.file?(@full_name)
      flash[:err_msg]="文件 #{@file_name} 不存在"
      return
    end

    @dump_file=File.new(@full_name)

    key=params[:id].to_i
    unless key == check_key(@dump_file)
      @dump_file=nil
      flash[:err_msg]="文件校验码错误： #{key}"
    end
  end

end
