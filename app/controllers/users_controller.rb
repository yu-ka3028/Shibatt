class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, notice: 'User was successfully created.'
    else
<<<<<<< Updated upstream
      Rails.logger.debug(@user.errors.full_messages.join("\n"))
      render "new"
=======
      flash.now[:alert] = 'User could not be created.'
      render :new, status: :unprocessable_entity
>>>>>>> Stashed changes
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
end
