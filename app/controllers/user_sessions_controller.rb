class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def create
    @user = login(params[:user_session][:username], params[:user_session][:password])
  
    if @user
      session[:username] = params[:user_session][:username]
      session[:profileImageUrl] = params[:user_session][:profileImageUrl]
      redirect_back_or_to root_path, notice: 'Login successful'
    else
      flash.now[:alert] = 'Login failed'
      render :new, status: :unauthorized
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'Logged out!'
  end
end
