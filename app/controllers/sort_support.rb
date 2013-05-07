# -*- encoding : utf-8 -*-

module SortSupport

  def tune_order
    field=order_field.to_sym
    mc=model_class
    m1=mc.find(params[:id1])
    if params[:dir] == 'up' or params[:dir] == 'down'
      m2=mc.find(params[:id2])
      o1,o2=m1.send(field), m2.send(field)
      m1.update_column field, o2
      m2.update_column field, o1
    elsif params[:dir] == 'top'
      m1.update_column field, mc.minimum(order_field)-1
    elsif params[:dir] == 'bottom'
      m1.update_column field, mc.maximum(order_field)+1
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def model_class
    end_of_association_chain
  end unless self.method_defined? :model_class

  def order_field
    's_order'
  end

  def create_resource(object)
    object.send :"#{order_field}=", (model_class.maximum(order_field)||100)+1
    super
  end

end
