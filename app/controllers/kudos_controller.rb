class KudosController < ApplicationController
  before_filter :find_post
  skip_before_filter :verify_authenticity_token  

  def create
    @kudo = @post.kudos.build()
    if @kudo.save
      render :json => {kudo: @kudo, success: true}
    else
      render :json => {kudo: @kudo, success: false, errors: @kudo.errors}
    end
  end
  
  
  private

  def find_post
    @post = Post.find(params[:post_id])
  end

end
