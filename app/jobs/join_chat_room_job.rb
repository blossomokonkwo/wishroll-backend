class JoinChatRoomNotificationJob < ApplicationJob
    queue_as :notifications
    def perform(user_id, chat_room_id)
        joined_user = User.find(user_id)
        chat_room_users = ChatRoomUser.where(chat_room_id: chat_room_id).includes([:user])
        chat_room = ChatRoom.find(chat_room_id)
        if chat_room_users.any?
            app = Rpush::Client::ActiveRecord::App.find_by_name("wishroll-ios")
            chat_room_users.each do |chat_room_user|
                unless chat_room_user.muted
                    user = chat_room_user.user
                    unless user.id == joined_user.id
                        device = user.current_device
                        if device
                            notification = Rpush::Apns::Notification.new
                            notification.app = app
                            notification.device_token = device.device_token
                            if chat_room.name
                                notification.alert = "#{chat_room.name}\n#{joined_user.username} has joined the chat... 😳"
                            else
                                notification.alert = "#{joined_user.username} has joined the chat... 😳"
                            end
                            notification.sound = ''
                            notification.category = "Chat Room"
                            notification.data = {}
                            notification.save!
                        end
                    end
                end
            end
        end
    end
    
end