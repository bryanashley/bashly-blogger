class CommenterSessionsController < ApplicationController

  def create
    commenter = Commenter.from_omniauth(env["omniauth.auth"])
    session[:commenter_id] = commenter.id
    redirect_to root_url, notice: "Signed in!"
  end

  def destroy
    session[:commenter_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

end