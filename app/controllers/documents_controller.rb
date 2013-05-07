# -*- encoding : utf-8 -*-

class DocumentsController < ProjectResourceController

  def create
    super { set_associations 'author', 'user' }
  end

  def update
    super { set_associations 'author', 'user' }
  end
end
