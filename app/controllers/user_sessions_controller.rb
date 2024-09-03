class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :create_from_liff]

  def create
    @user = login(params[:username], params[:password])

    if @user
      redirect_back_or_to root_path, notice: 'Login successful'
    else
      flash.now[:alert] = 'Login failed'
      render :new, status: :unauthorized
    end
  end

  def create_from_liff
    username = params[:username]
    profile_image_url = params[:profile_image_url]
  
    @user = User.find_by(username: username)
    if @user
      auto_login(@user)
      render json: { status: 'ok' }
    else
      @user = User.new(username: username, profile_image_url: profile_image_url)
      @user.password = SecureRandom.hex(16) # パスワードを設定
      if @user.save
        auto_login(@user)
        render json: { status: 'ok' }
      else
        render json: { status: 'error', message: 'User could not be created.' }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'Logged out!'
  end
end
