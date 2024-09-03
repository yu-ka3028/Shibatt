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

  def create_from_web
    provider = params[:provider]
    if @user = login_from(provider)
      puts "Logged in from #{provider}"
      redirect_to root_path, notice: "#{provider.titleize}からログインしました!"
    else
      begin
        @user = User.find_by(line_user_id: @user.authentications.find_by(provider: provider).uid) || create_from(provider)
        puts "Created user from #{provider}: #{@user.inspect}"
        # LINEから取得したuserIdをローカルでline_user_idに保存
        @user.update(line_user_id: @user.authentications.find_by(provider: provider).uid)
        puts @user.line_user_id
  
        reset_session
        auto_login(@user)
    
        redirect_to root_path, notice: "#{provider.titleize}からログインしました!"
      rescue => e
        puts "Failed to login from #{provider}: #{e.message}"
        redirect_to root_path, alert: "#{provider.titleize}からのログインに失敗しました!"
      end
    end
  end

  def create_from_liff
    username = params[:user_session][:username]
    line_user_id = params[:user_session][:line_user_id]
    Rails.logger.info "Creating user with username: #{username}, line_user_id: #{line_user_id}"
    profile_image_url = params[:user_session][:profileImageUrl]
  
    # line_user_idが存在するか確認し、存在しない場合は新しいユーザーを作成
    @user = User.find_by(line_user_id: line_user_id) || User.create(username: username, line_user_id: line_user_id)
  
    if @user.persisted?
      session[:username] = username
      session[:profileImageUrl] = profile_image_url
      auto_login(@user)
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
