json.posts @recommended_posts.each do |post|
    json.post do
        json.id post.id
        json.user_id post.user_id
        json.view_count post.view_count
        json.likes_count post.likes_count
        if post.likes.find_by(user_id: @id)
            json.liked true
        else
            json.liked false
        end
        json.comments_count post.comments_count
        json.original_post_id post.original_post_id
        json.caption post.caption
        json.created_at post.created_at
        json.media_url post.posts_media_url
    end
    json.user do
        json.username @post_user.username
        json.is_verified @post_user.is_verified
        json.profile_picture_url @post_user.profile_picture_url
    end
end
