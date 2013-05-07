# -*- encoding : utf-8 -*-

class MeetingsController < ProjectResourceController

  def create
    super { set_associations 'participant', 'user' }
  end

  def update
    super { set_associations 'participant', 'user' }
  end
end
