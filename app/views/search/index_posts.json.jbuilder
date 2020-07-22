json.array! @posts.each do |post|
    json.id post.id
    json.created_at post.created_at
    json.likes_count post.likes_count
    json.view_count post.view_count
    json.caption post.caption
    json.liked post.liked?(@current_user)
    json.thumbnail_url post.thumbnail_url
    json.comments_count post.comments_count
    json.media_url post.media_url
end