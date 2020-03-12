class MessageRelayJob < ApplicationJob
  queue_as :messages

  def perform(message)
    ChatRoomsChannel.broadcast_to(message.chat_room, message: message)
  end
end
