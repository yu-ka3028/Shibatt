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
    username = params[:user_session][:username]
    line_user_id = params[:user_session][:line_user_id]
    profile_image_url = params[:user_session][:profileImageUrl]
  
    # line_user_idが存在するか確認し、存在しない場合は新しいユーザーを作成
    @user = User.find_by(line_user_id: line_user_id) || User.create(username: username, line_user_id: line_user_id)
  
    if @user.persisted?
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
