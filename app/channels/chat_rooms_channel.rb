class ChatRoomsChannel < ApplicationCable::Channel
  def subscribed
    #when a user is subscribed to a particular chatroom's channel, they recieve all the messages that are sent to that chat room. 
    #The user subscribes to this channel when they are 
    @chat_room = ChatRoom.find(params[:chat_room_id])
    reject unless @chat_room.users.exists?(id: current_user.id)
    stream_for @chat_room, coder: ActiveSupport::JSON do |message|

    end 

  end

  def unsubscribed
    
  end
end
