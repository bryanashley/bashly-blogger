class PostsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]

  def index
    if params.has_key?(:c)
      @posts = Post.category(params[:c]).order("created_at desc")
    elsif params.has_key?(:s)
      @posts = Post.search_all(params[:s])
    else
      @posts = Post.order("created_at desc")
    end
  end
  
  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.posts.build()
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to post_path(@post), :notice => "Post Created"
    else
      render "new"
    end
  end

  private 

  def post_params
    params.require(:post).permit(:title, :subtitle, :content, :tagline)
  end

end