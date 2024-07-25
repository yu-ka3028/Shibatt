class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.build(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, notice: 'User was successfully created.'
    else
      render "new"
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
end
