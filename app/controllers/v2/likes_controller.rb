class V2::LikesController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        if params[:roll_id] and roll = Roll.find(params[:roll_id])
            begin
                like = roll.likes.create!(user: current_user)
                CreateLocationJob.perform_now(params[:ip_address], params[:timezone], like.id, like.class.name)
                render json: nil, status: :created
            rescue => exception
                render json: {error: "Could not like the roll: #{roll}"}, status: :bad_request
            end            
        elsif params[:comment_id] and comment = Comment.find(params[:comment_id])
            begin
                like = comment.likes.create!(user: current_user)
                CreateLocationJob.perform_now(params[:ip_address], params[:timezone], like.id, like.class.name)
                render json: nil, status: :created                
            rescue => exception
                render json: {created: "Could not like the comment: #{comment}"}, status: :bad_request
            end
        elsif params[:post_id] and post = Post.find(params[:post_id])
            begin
                like = post.likes.create!(user: current_user)
                CreateLocationJob.perform_now(params[:ip_address], params[:timezone], like.id, like.class.name)
                render json: nil, status: :created
            rescue => exception
                render json: {error: "Could not like the post: #{post}"}, status: :bad_request
            end
        else
            render json: {error: "Could not locate a resource to complete the operation"}, status: :not_found
        end
    end

    def destroy
        like = Like.where(likeable_type: params[:likeable_type], user: current_user, likeable_id: params[:likeable_id]).first
        if like.destroy
            render json: nil, status: :ok
        else
            render json: {error: "An error occured that prevented the like - #{like} - from being destroyed"}, status: 500
        end
    end
    
    # Returns the users that have liked a resource
    def index
        if params[:post_id] and post = Post.find(params[:post_id])
            @current_user = current_user
            limit = 15
            offset = params[:offset]
            @users = Array.new
            if offset
                @users = User.joins(:likes).where(likes: {likeable: post}).order('likes.created_at DESC').offset(offset).limit(limit)
              else
                @users = User.joins(:likes).where(likes: {likeable: post}).order('likes.created_at DESC').limit(limit)
              end
              if @users.any?
                @users.to_a.delete_if do |user|
                    user.blocked_users.include?(current_user) or current_user.blocked_users.include?(user)
                end
                render :index, status: :ok
              else
                render json: nil, status: :not_found
              end
        elsif params[:comment_id] and comment = Comment.find(params[:comment_id])
            @current_user = current_user
            limit = 15
            offset = params[:offset]
            @users = Array.new
            if offset
                @users = User.joins(:likes).where(likes: {likeable: comment}).order('likes.created_at DESC').offset(offset).limit(limit)
            else
                @users = User.joins(:likes).where(likes: {likeable: comment}).order('likes.created_at DESC').limit(limit)
            end
            if @users.any?
                @users.to_a.delete_if do |user|
                    user.blocked_users.include?(current_user) or current_user.blocked_users.include?(user)
                end
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        elsif params[:roll_id] and roll = Roll.find(params[:roll_id])
            @current_user = current_user
            limit = 15
            offset = params[:offset]
            @users = Array.new
            if offset
                @users = User.joins(:likes).where(likes: {likeable: roll}).order('likes.created_at DESC').offset(offset).limit(limit)
              else
                @users = User.joins(:likes).where(likes: {likeable: roll}).order('likes.created_at DESC').limit(limit)
              end
              if @users.any?
                @users.to_a.delete_if do |user|
                    user.blocked_users.include?(current_user) or current_user.blocked_users.include?(user)
                end
                render :index, status: :ok
              else
                render json: nil, status: :not_found
              end
        else
            render json: {error: "Could not locate a resource to complete the operation"}, status: :not_found
        end
    end
end