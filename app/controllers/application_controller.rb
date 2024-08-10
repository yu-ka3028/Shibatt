class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def not_authenticated
    redirect_to login_path
  end
  
  def logged_in?
    !!current_user
  end
end
