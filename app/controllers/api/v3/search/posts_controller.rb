class Api::V3::Search::PostsController < ApplicationController

    def index
        limit = 18
        offset = params[:offset]
        @posts = Post.fetch_multi(Tag.joins(post: {media_item_attachment: :blob}).where("active_storage_blobs.content_type ILIKE ?", "%#{params['content-type']}%").search(params[:q]).limit(limit).offset(offset).pluck(:post_id)).uniq {|p| p.id}
        if @posts.any?            

            begin
                authorize_by_access_header!
                @current_user = current_user
            rescue => exception
                
                #   handle unauthorization
                
            end



            
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end