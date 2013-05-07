# -*- encoding : utf-8 -*-

class Sys::ModsController < Sys::AdminController
  actions :all, :except => [:show]
  include SortSupport

  private

  def check_sysrole
    require_root
  end
end
