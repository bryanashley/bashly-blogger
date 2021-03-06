class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user, :require_user, :current_commenter

  def require_user
    redirect_to root_url unless current_user.present?
  end

  private

  def current_commenter
    @current_commenter ||= Commenter.find(session[:commenter_id]) if session[:commenter_id]
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
