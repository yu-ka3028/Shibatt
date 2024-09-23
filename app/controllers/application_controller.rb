class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user

  private
  
  def not_authenticated
    redirect_to login_path
  end
  
  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    @current_user.profile_image_url = session[:profileImageUrl] if @current_user
    @current_user
  end

  
end
