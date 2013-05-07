# -*- encoding : utf-8 -*-

class Sys::ProjMod < ActiveRecord::Base
  include ::ModelSupport
  include ::SysLog

  belongs_to_project
  belongs_to :mod

  def luu_id
    @luu_id||project.luu_id
  end

  def luu_ip
    @luu_ip||project.luu_ip
  end

  private

  def log_abstract(action)
    "#{project.code}: #{mod.name}"
  end

end
