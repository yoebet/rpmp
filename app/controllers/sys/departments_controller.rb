# -*- encoding : utf-8 -*-

class Sys::DepartmentsController < Sys::AdminController
  actions :all, :except => [:show]
  include SortSupport

end
