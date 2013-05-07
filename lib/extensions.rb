# -*- encoding : utf-8 -*-

require 'active_support/time_with_zone.rb'

module DateExt

  def date_ydyn
    "#{year}-#{mon}-#{day}"
  end

  def date_zh
    "#{year}年#{mon}月#{day}日"
  end

  def wday_zh
    ['日', '一', '二', '三', '四', '五', '六'][self.wday]
  end

  def date_ydyn_w
    "#{year}-#{mon}-#{day}（#{wday_zh}）"
  end
end


module TimeExt

  def datetime_ydyn
    strftime("%Y-%-m-%-d %H:%M")
  end

  def datetime_dyn
    self.today? ? strftime("%H:%M") : strftime("%Y-%-m-%-d %H:%M")
  end

  def datetime_ydyn_w
    strftime("%Y-%-m-%-d（#{wday_zh}） %H:%M")
  end
end

class ActiveSupport::TimeWithZone
  include ::DateExt
  include ::TimeExt
end

class Time
  include ::TimeExt
end

class Date
  include ::DateExt
end

class NilClass
  def name
    ''
  end
end
