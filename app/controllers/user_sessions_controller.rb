class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def create
    @user = login(params[:username], params[:password])

    if @user
      redirect_back_or_to root_path, notice: 'Login successful'
    else
      flash.now[:alert] = 'Login failed'
<<<<<<< Updated upstream
      render :new
=======
      render :login_path, status: :unauthorized
>>>>>>> Stashed changes
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'Logged out!'
  end
end
