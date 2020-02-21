json.followers @followers.each do |user|
    json.user do
        json.username user.username
        json.full_name user.full_name
        json.is_verified user.is_verified
        json.profile_picture_url url_for(@user.profile_picture) if @user.profile_picture.attached?
        json.is_following user.follower_users.include?(@current_user) ? true : false
    end
end
