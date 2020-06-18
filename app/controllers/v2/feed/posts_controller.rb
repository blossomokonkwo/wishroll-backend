class V2::Feed::PostsController < ApplicationController
    before_action :authorize_by_access_header!
    def feed
        offset = params[:offset]
        limit = 12
        @id = current_user.id
        @posts = Array.new
        recommended_posts = recommend_posts(limit: limit/2, offset: offset)
        recommend_posts.map {|p| @posts << p} if recommend_posts.present?
        feed_users = current_user.followed_users.to_a
        feed_users << current_user
        Post.includes(:user).where(user: feed_users).order(created_at: :desc).offset(offset).limit(limit).to_a.map {|p| @posts << p}
        if @posts.any?
            @posts.sort! {|a,b| b.created_at <=> a.created_at}
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end

    def recommend_posts(limit: 12, offset: 0)
        begin
            post = current_user.viewed_posts.joins(:tags).where('tags.text != ?', nil).limit(1).first
            english_articles = ["the", "a", "when" "some", "they", "back", "because", "if", "in", "i", "can't", "but", "where", "why", "we"]
            keywords = Array.new
            post.tags.pluck(:text).map {|word| word.split(' ').delete_if {|word| english_articles.include?(word)}.map {|t| keywords << "%#{t}%"}}
            post.caption.split(' ').delete_if {|word| english_articles.include?(word)}.map {|word| keywords << "%#{word}%"}
            return Post.joins(:tags).where("tags.text ILIKE ANY (array[?]) or posts.caption ILIKE ANY (array[?])",keywords, keywords).distinct.includes([user: :blocked_users]).order(likes_count: :desc, view_count: :desc, id: :asc).offset(offset).limit(limit).to_a
        rescue => e
            if e.instance_of?(ActiveRecord::RecordNotFound)
                #handle the not found error
                puts 'Recommended posts not found'
            end
        end
    end
    
    
end