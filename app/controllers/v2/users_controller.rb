class V2::UsersController < ApplicationController
    before_action :authorize_by_access_header!

    def show
        @user = User.find(params[:id]) || User.find_by(params[:username])
        if @user
            if current_user.blocked_users.include?(@user)
                render json: {error: "#{current_user.username} has blocked #{@user.username}"}, status: :forbidden
            elsif @user.blocked_users.include?(@user)
                render json: {error: "#{@user.username} has blocked you}"}, status: :forbidden
            else
                @following = nil
                if current_user != @user
                    @following = current_user.following?(@user)
                end
                render :show, status: :ok
            end
        else
            render json: {error: "#{params[:username]} does not have an account on WishRoll"}, status: :not_found
        end
    end


    def posts
        @user = User.find(params[:user_id])
        offset = params[:offset] #use the created at field to offset the data
        limit = 18
        if @user
            unless current_user.blocked_users.include?(@user) or @user.blocked_users.include?(current_user)
                @posts = Array.new
                if offset 
                    @posts = @user.created_posts(limit: limit, offset: offset)
                else 
                    @posts = @user.created_posts(limit: limit)
                end
                if @posts.any?
                    @id = current_user.id
                    render :posts, status: :ok
                else
                    render json: {error: "#{params[:username]} doesn't have any posts"}, status: :not_found
                end  
            else
                render json: nil, status: :forbidden
            end

        else
            render json: {error: "#{params[:username]} does not have an account on WishRoll"}, status: :not_found 
        end
    end

    def liked_posts
        @user = User.find(params[:user_id])
        offset = params[:offset]
        limit = 18
        if @user
            unless current_user.blocked_users.include?(@user) or @user.blocked_users.include?(current_user)
                @posts = Array.new
                if offset
                    @posts = @user.liked_posts(limit: limit, offset: offset) #in later versions, there will be an optimization for speed using offset
                else
                    @posts = @user.liked_posts(limit: limit)
                end
                if @posts.any? 
                    @id = current_user.id
                    render :liked_posts, status: :ok
                else
                    render json: {error: "#{params[:username]} hasn't liked any posts"}, status: :not_found
                end  
            else
                render json: nil, status: :forbidden
            end

        else
            render json: {error: "#{params[:username]} does not have an account on WishRoll"}, status: :not_found 
        end
    end
    
    
    
end