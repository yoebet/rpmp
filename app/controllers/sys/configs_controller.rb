# -*- encoding : utf-8 -*-

class Sys::ConfigsController < Sys::AdminController
  actions :all, :except => [:show]

  private

  def check_sysrole
    require_root
  end
end
