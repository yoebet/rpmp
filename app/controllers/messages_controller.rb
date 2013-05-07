# -*- encoding : utf-8 -*-

class MessagesController < InheritedResources::Base
  actions :all, :except => [:edit, :update]

  def index
    @message_receives, @receives_has_more=@cu.message_receives.limit(6), false
    @message_receives, @receives_has_more=@message_receives.first(5), true if @message_receives.size()>5
    @messages, @messages_has_more=@cu.sent_messages.limit(6), false
    @messages, @messages_has_more=@messages.first(5), true if @messages.size()>5
  end

  def received
    @message_receives=@cu.message_receives.paginate(:page => params[:page])
  end

  def sent
    @messages=@cu.sent_messages.paginate(:page => params[:page])
  end

  def create
    receiver_id=params[:receiver_id]
    receiver_ids=params[:receiver_ids]
    multi_receiver=params[:multi_receiver]
    unless multi_receiver=='1'
      receiver_ids=[receiver_id]
    end
    @message=Message.new(params[:message])
    replied_message_id=@message.replied_message_id
    if replied_message_id and multi_receiver
      receiver_ids.insert(0, receiver_id)
    end

    message_receive=nil
    if replied_message_id
      replied_message=Message.find replied_message_id
      if replied_message
        message_receive=replied_message.message_receives.find_by_receiver_id @cu.id
        @message.replied_message_id=nil unless message_receive
      end
    end

    @message.message_receives=receiver_ids.uniq.collect do |rid|
      MessageReceive.new(:receiver_id => rid, :read => false, :replied => false)
    end
    @message.sender_id=@cu.id
    @message.save

    if message_receive and not message_receive.replied
      message_receive.replied=true
      message_receive.save
    end

    render '_message_li', :layout => false, :locals => {:message => @message}
  end

  def show
    @message=Message.find params[:id]
    unless is_sender_or_receiver(@message)
      render :text => ''
      return
    end
    receiver=@message.message_receives.find_by_receiver_id @cu.id
    if receiver and not receiver.read
      receiver.read=true
      receiver.save
    end
    render '_message', :layout => false, :locals => {:message => @message}
  end

  def reply
    @replied_message=Message.find params[:id]
    unless is_sender_or_receiver(@replied_message)
      render :text => '' and return
    end
    @message=Message.new
    @message.replied_message_id=@replied_message.id
    @message.title="RE:#{@replied_message.title || ''}"
    @message.content="（#{@replied_message.sender.name}：#{@replied_message.content}）\n"
    render '_reply_message', :layout => false, :locals => {:message => @message, :replied_message => @replied_message}
  end

  def destroy
    @message=Message.find params[:id]
    if @message.nil? or @cu.id != @message.sender.id
      render :nothing => true and return
    end
    destroy! do |format|
      format.js { render :js => "$('#m#{params[:id]}').fadeOut(1000,function(){$(this).remove()})" }
    end
  end

  protected

  def is_sender_or_receiver(message)
    return false unless message
    return true if @cu.id == message.sender.id
    message.message_receives.find_by_receiver_id(@cu.id)
  end

end
