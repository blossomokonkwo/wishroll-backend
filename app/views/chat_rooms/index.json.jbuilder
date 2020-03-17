json.array! @chat_rooms.includes([:recent_message]).each do |chat_room|
    cache chat_room, expires_in: 30.minutes do
        json.chat_room do 
            json.id chat_room.id
            json.name chat_room.name 
            json.created_at chat_room.created_at
            json.num_users chat_room.num_users
            json.recent_message chat_room.recent_message
            json.joined  chat_room.users.include?(@current_user) ? true : false
        end
        json.chat_room_users chat_room.users.each do |user|
            json.username user.username
            json.profile_picture_url user.profile_picture_url
            json.full_name user.full_name
            json.is_verified user.is_verified
        end
    end
end
