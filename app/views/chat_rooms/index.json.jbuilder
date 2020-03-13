json.array! @chat_rooms.each do |chat_room|
    cache chat_room. expires_in: 30.minutes do
        json.id chat_room.id
        json.name chat_room.name 
        json.created_at chat_room.created_at
        json.num_users chat_room.num_users
        json.recent_message chat_room.recent_message
        json.joined  chat_room.users.include?(@current_user) ? true : false
    end
end
