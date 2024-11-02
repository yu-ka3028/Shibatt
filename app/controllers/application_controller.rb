class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user

  private

  def require_login
    unless logged_in?
      not_authenticated
    end
  end
  
  def not_authenticated
    redirect_to login_path
  end
  
  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= begin
      if session[:user_id]
        if session[:provider] == 'line'
          User.find_by(provider: 'line', uid: session[:uid])
        else
          User.find_by(id: session[:user_id])
        end
      end
    end
  end
  
end
