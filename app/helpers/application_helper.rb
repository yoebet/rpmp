# -*- encoding : utf-8 -*-

module ApplicationHelper
  def css_class_by_status(status)
    case status
      when Const::STATUS_UNRECEIVED then 'status_unreceived'
      when Const::STATUS_COMPLETED then 'status_complete'
      when Const::STATUS_UNCOMPLETED then 'status_uncomplete'
      when Const::STATUS_TO_TEST then 'status_to_test'
      else
        ''
    end
  end

  def css_class_by_importance(importance)
    "importance_#{importance}"
  end

  def css_class_by_urgency(urgency)
    "urgency_#{urgency}"
  end

  def css_class_by_priority(priority)
    "priority_#{priority}"
  end

  def css_class_by_work_rank(work_rank)
    "work_rank_#{work_rank}"
  end

  def customers_and_members_option_groups(customers, members, selected_key = nil)
    [[customers, Customer.name, '客户'],
     [members, Sys::User.name, '项目成员']
    ].collect do |users,prefix,label|
      "<optgroup label=\"#{label}\">" +
         options_for_select(users.map { |u| [u.name,"#{prefix}##{u.id}"] },selected_key) +
        '</optgroup>'
    end.join.html_safe
  end

  def associated_resources_for_edit(res,cur,limit=10)
    a=@project.send(res.to_s.pluralize).order('id DESC').limit(limit)
    cur.each {|r| a << r unless a.include?(r)}
    a
  end

  def message_title_safe(message)
    return '（无）' if message.title.blank?
    return message.title if message.title.length <= 22
    message.title[0..21] + '...'
  end

  def message_receive_info(message_receive,rtip=false)
    name=message_receive.receiver.name
	return name unless rtip
	return name+'<span class="subscript">（未读）</span>' unless message_receive.read
	return name+'<span class="subscript">（已回复）</span>' if message_receive.replied
    name
  end

  def remote_options
    {:remote => true, 'data-type' => 'html', 'data-update' => 'rmain'}
  end

  def resource_history_link_options
    remote_options.merge! 'data-update' => 'resource_history', 'data-toggle' => 'true'
  end

  def remote_form_tag(url_for_options = {}, options = {}, &block)
    options.merge! remote_options
    form_tag(url_for_options, options, &block)
  end

  def remote_filter_form_tag(url_for_options = {}, options = {}, &block)
    options[:method]='get'
    if options[:class]
      options[:class]="filter #{options[:class]}"
    else
      options[:class]="filter"
    end
    remote_form_tag(url_for_options, options, &block)
  end

  class PageLinkRenderer < WillPaginate::ActionView::LinkRenderer
    def remote_options
      {'data-remote' => 'true', 'data-type' => 'html', 'data-update' => 'rmain'}
    end
    def tag(name, value, attributes = {})
      attributes.merge! remote_options if name==:a
      super
    end
  end

  def will_paginate(collection_or_options = nil, options = {})
    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end
    unless options[:renderer]
      options = options.merge :renderer => PageLinkRenderer
    end
    super *[collection_or_options, options].compact
  end

  def non_zero(n)
    n.to_i unless nil_zero?(n)
  end

  def nil_zero?(n)
    n.nil? or n.zero?
  end

  def sum_as_int(*args)
    args.compact.sum {|i|i.to_i}
  end

end
