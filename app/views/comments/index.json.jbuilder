json.array! @comments.each do |comment|
    @user = User.find(comment.user_id)
    json.id comment.id
    json.body comment.body
    json.user_id comment.user_id
    json.post_id comment.post_id
    json.created_at comment.created_at
    json.updated_at comment.updated_at
    json.original_comment_id comment.original_comment_id
    json.replies_count comment.replies_count
    json.user_profile_image_url url_for(@user.profile_picture)
    json.username @user.username
    json.is_verified @user.is_verified
end