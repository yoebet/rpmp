# -*- encoding : utf-8 -*-

class AttachmentsController < ProjectResourceController
  actions :all, :except => [:show, :edit]

  def download
    send_attachment
  end

  def image
    send_attachment :disposition => 'inline' unless request.xhr?
  end

  protected

  def send_attachment(options={})
    @attachment=Attachment.find(params[:id])
    raise if @attachment.project_id != @project.id
    o = {:filename => @attachment.name, :type => @attachment.content_type, :disposition => 'attachment'}
    send_data(@attachment.content, o.update(options))
  end

end
