class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

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
    line_user_id = params[:line_user_id]
    profile_image_url = params[:profile_image_url]
  
    # ユーザー名が存在するか確認し、存在しない場合は新しいユーザーを作成
    @user = User.find_by(username: username) || User.new(username: username, line_user_id: line_user_id)
  
    if @user.save
      auto_login(@user)
      session[:username] = username
      session[:profileImageUrl] = profile_image_url
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
