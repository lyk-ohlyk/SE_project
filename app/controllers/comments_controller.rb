class CommentsController < ApplicationController
  before_action :signed_in_user, only:[:create, :destroy]
  before_action :find_course!

  def create
    @comment = @course.comments.build(comment_params)
    @comment.user = current_user

    render json: { errors: @comment.errors }, status: :unprocessable_entity unless @comment.save
  end

  def destroy
    @comment = @course.comments.find(params[:id])

    if @comment.user_id == @current_user.id
      @comment.destroy
      render json: {}
    else
      render json: { errors: { comment: ['不是您的评论'] } }, status: :forbidden
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end
    def find_course!
      @course = Course.find(params[:id])
    end
end