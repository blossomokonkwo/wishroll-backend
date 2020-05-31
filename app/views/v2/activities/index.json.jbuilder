json.array! @activities.each do |activity|
    active_user = activity.active_user
    cache activity, expires_in: 1.minute do
        json.id activity.id
        json.created_at activity.created_at
        json.phrase activity.activity_phrase
        json.type activity.activity_type
        if activity.activity_type == "Roll" and roll = Roll.where(id: activity.content_id).first
            json.roll do
                json.id roll.id
                json.media_url roll.media_url
                json.caption roll.caption
                json.thumbnail_url roll.thumbnail_url
                json.likes roll.likes_count
                json.shares roll.shares
                json.comments_count roll.comments_count
                json.views roll.views
                json.viewed roll.viewed?(@id)
                json.liked roll.liked?(@id)
                json.created_at roll.created_at
                json.creator do
                    user = roll.user
                    json.id user.id
                    json.username user.username
                    json.avatar user.avatar_url
                    json.verified user.verified 
                end
            end
        elsif activity.activity_type == "Post" and post = Post.where(id: activity.content_id).first
            json.post do
                json.id post.id
                json.media_url post.media_url
                json.caption post.caption
                json.thumbnail_url post.thumbnail_url
                json.likes post.likes_count
                json.shares post.share_count
                json.comments_count post.comments_count
                json.views post.view_count
                json.viewed post.viewed?(@id)
                json.liked post.liked?(@id)
                json.created_at post.created_at
                json.updated_at post.updated_at
                json.creator do
                    user = post.user
                    json.id user.id
                    json.username user.username
                    json.avatar user.avatar_url
                    json.verified user.verified
                end               
            end
        elsif activity.activity_type == "Comment" and post = Comment.where(id: activity.content_id).first.post
            json.post do
                json.id post.id
                json.media_url post.media_url
                json.caption post.caption
                json.thumbnail_url post.thumbnail_url
                json.likes post.likes_count
                json.shares post.share_count
                json.comments_count post.comments_count
                json.views post.view_count
                json.viewed post.viewed?(@id)
                json.liked post.liked?(@id)
                json.created_at post.created_at
                json.updated_at post.updated_at
                json.creator do
                    user = post.user
                    json.id user.id
                    json.username user.username
                    json.avatar user.avatar_url
                    json.verified user.verified
                end
            end
        end
        json.active_user do 
            json.id active_user.id
            json.username active_user.username
            json.avatar active_user.avatar_url
            json.verified active_user.verified
        end
    end
end
