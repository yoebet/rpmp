# -*- encoding : utf-8 -*-

[{code: 'tag', name: '标签', def_included: false},
 {code: 'modu', name: '系统模块', def_included: true},
 {code: 'member', name: '项目成员', def_included: false},
 {code: 'document', name: '项目文档', def_included: true},
 {code: 'meeting', name: '会议纪要', def_included: true},
 {code: 'customer', name: '客户', def_included: false},
 {code: 'communication', name: '客户沟通', def_included: true},
 {code: 'milestone', name: '里程碑', def_included: true},
 {code: 'requirement', name: '需求', def_included: true},
 {code: 'test', name: '测试', def_included: true},
 {code: 'issue', name: '问题', def_included: true},
 {code: 'task', name: '任务', def_included: true},
 {code: 'my_task', name: '我的任务', def_included: true},
 {code: 'task_statistic', name: '任务统计', def_included: true},
 {code: 'weekly', name: '周报', def_included: true},
 {code: 'revision', name: '代码提交', def_included: true},
 {code: 'activity', name: '项目动态', def_included: true}].each do |mod|
  Sys::Mod.create mod
end

[{name: 'scm.base', zh_name: '配置管理库', value: 'http://192.168.0.12/svn/', memo: ''},
 {name: 'scm.base.wlan', zh_name: 'svn外网路径', value: 'http://www.domain.com/svn/', memo: ''},
 {name: 'db_dump.diretory', zh_name: '数据库备份目录', value: '~/rpmp_dump', memo: ''},
 {name: 'db_dump.script', zh_name: '数据库备份命令',
  value: 'mysqldump -u<U> -p<P> <D> | gzip > <DIR>/`date +%Y%m%d%H%M%S`.dump.gz',
  memo: '<H>: host\r\n<U>: username\r\n<P>: password\r\n<D>: database\r\n<DIR>: dump directory'},
 {name: 'db_dump.script.ia', zh_name: '数据库备份命令（不含附件表）',
  value: 'mysqldump -u<U> -p<P> <D> --ignore-table=<D>.attachments | gzip > <DIR>/`date +%Y%m%d%H%M%S`_ia.dump.gz',
  memo: '<H>: host\r\n<U>: username\r\n<P>: password\r\n<D>: database\r\n<DIR>: dump directory'},
 {name: 'task.rank_weight', zh_name: '任务评分绩效值', value: '0,0.6,1,1.5,2',
  memo: '五个递增数值，分别表示任务评分C到AAA的绩效值。逗号分割。'}
].each do |config|
  Sys::Config.create config
end

[{name: '项目经理', description: 'PM'},
 {name: '开发人员', description: ''}].each do |role|
  Sys::Role.create role
end

[{code: 'dev', name: '项目研发部'}].each do |dep|
  Sys::Department.create dep
end

[{name: '管理员01', department_id: 1, password: 'wy2013', password_must_update: true}].each do |user|
  u=Sys::User.new user
  u.set_root
  u.save
end
