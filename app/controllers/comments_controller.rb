class CommentsController < ApplicationController
  before_filter :find_post
  skip_before_filter :verify_authenticity_token

  def create
    @comment = @post.comments.build(comment_params)
    if @comment.save
      broadcast("/comments/#{@post.id}", partial: render_to_string("/posts/_comment.html.erb", :layout => false, :locals => {comment: @comment}),)
      render :json => {comment: @comment,  
                       success: true}
    else
      render :json => {comment: @comment, success: false, errors: @comment.errors}
    end
  end


  private 

  def broadcast(channel, message)
    message = {:channel => channel, :data => message, :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def find_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:author, :content)
  end
end