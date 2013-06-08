class CommentsController < ApplicationController
  before_filter :find_post
  skip_before_filter :verify_authenticity_token

  def create
    @comment = @post.comments.build(comment_params)
    if @comment.save
      render :json => {comment: @comment, success: true, partial: render_to_string(:partial => "posts/comment", :locals => {:comment => @comment})}
    else
      render :json => {comment: @comment, success: false, errors: @comment.errors}
    end
  end


  private 

  def find_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:author, :content)
  end
end