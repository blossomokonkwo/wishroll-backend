class V2::CommentsController < ApplicationController
    before_action :authorize_by_access_header!
    def create
        if params[:post_id] and post = Post.fetch(params[:post_id])
            begin
                @comment = post.comments.create!(body: params[:body], user_id: current_user.id, original_comment_id: params[:original_comment_id])
                @user = current_user
                CommentActivityJob.perform_now(@comment.id, current_user.id)
                render :create, status: :created
            rescue => exception
                puts @comment.errors.inspect
                render json: {error: "Couldn't create comment for post #{post}", messages: @comment.errors}, status: 500
            end
        else
            render json: {error: "Couldn't find resource "}, status: :not_found
        end
    end

    def update
        @comment = Comment.find(params[:id])
        @comment.update_attributes(body: params[:body])
        if @comment.save
            render :show, status: :ok
        else
            render json: {error: "Could not update comment with body #{params[:body]}"}, status: 500         
        end
    end
    
    def index
        limit = 10
        offset = params[:offset]
        if params[:post_id] and post = Post.fetch(params[:post_id])
            @comments = post.comments.order(created_at: :asc).offset(offset).limit(limit)
            if @comments.any?
                @current_user = current_user
                render :index, status: :ok
            else
                render json: nil, status: :not_found
            end
        else
            render json: {error: "Couldn't locate parent resource"}, status: :not_found
        end
    end
    
    def show
        render json: nil, status: :not_found
    end
    

    def destroy        
        @comment = Comment.find(params[:id])
        if @comment.destroy
            render json: nil, status: :ok
        else
            render json: {error: "There was an error with deleting your comment"}, status: 500
        end
    end
end