json.array! @users.each do |user|
    json.id user.id
    json.username user.username
    json.name user.name
    json.verified user.verified
    json.avatar user.avatar_url
    json.following @current_user.following?(user) if @current_user != user
end