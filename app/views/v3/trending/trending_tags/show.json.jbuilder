json.id @trending_tag.id
json.text @trending_tag.title
json.description @trending_tag.description
json.posts @posts.each do |post|
    json.id post.id
    json.created_at post.created_at
    json.updated_at post.updated_at
    json.media_url post.media_url
    json.thumbnail_url post.thumbnail_url
    json.comment_count post.comments_count
    json.viewed true #post.viewed?(@current_user)
    json.view_count post.view_count
    json.bookmarked false #post.bookmarked?(@current_user)
    json.bookmark_count post.bookmark_count
    json.liked false #post.liked?(@current_user)
    json.like_count post.likes_count
    json.share_count post.share_count
    json.caption post.caption
    user = User.fetch(post.user_id)
    json.creator do 
        json.id user.id
        json.username user.username
        json.verified user.verified
        json.avatar user.avatar_url
        json.following nil #@current_user.following?(user) if user != @current_user
    end
end
