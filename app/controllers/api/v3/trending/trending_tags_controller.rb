class Api::V3::Trending::TrendingTagsController < ApplicationController
    def index
        @trending_tags = TrendingTag.order(created_at: :desc).offset(params[:offset]).limit(5).to_a
        if @trending_tags.any?
            
            render :index, status: :ok
        else
            render json: nil, status: :not_found
        end
    end

    def show
        @trending_tag = TrendingTag.find(params[:id])
        @posts = @trending_tag.posts(offset: params[:offset], limit: 18).to_a
        if @posts.any?
            
            
            render :show, status: :ok
        else
            render json: nil, status: :not_found
        end
    end
    
end