# -*- encoding : utf-8 -*-

class Sys::RolesController < Sys::AdminController
  actions :all, :except => [:show]
  include SortSupport

end
