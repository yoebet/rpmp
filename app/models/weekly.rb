# -*- encoding : utf-8 -*-

class Weekly < ActiveRecord::Base
  include ModelSupport
  include ProjectResource

  validates :weekend, :presence => true
  validates :review, :presence => true
  validates :thought, :presence => true

  def filter(params)
    self.eq_filters||=%w(registrar_id weekend)
    default_filter(params)
  end

end

