class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :create_from_liff]

  def create
    @user = login(params[:username], params[:password])

    if @user
      redirect_back_or_to root_path, notice: 'ログインしました'
    else
      flash.now[:alert] = 'ログインに失敗しました'
      render :new, status: :unauthorized
    end
  end

  def create_from_line
    provider = params[:provider]
    if @user = login_from(provider)
      puts "Logged in from #{provider}"
      redirect_to root_path, notice: "#{provider.titleize}からログインしました!"
    else
      begin
        if @user
          @user = User.find_by(line_user_id: @user.authentications.find_by(provider: provider).line_user_id)
        end
        @user ||= create_from(provider)
        
        @user.update(line_user_id: @user.authentications.find_by(provider: provider).line_user_id)
  
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
  
    @user = User.find_by(line_user_id: line_user_id)
  
    unless @user
      @user = User.create(username: username, line_user_id: line_user_id, password: SecureRandom.hex, password_confirmation: SecureRandom.hex)
      @user.authentications.create(line_user_id: line_user_id) if @user.persisted?
    end
  
    if @user.persisted?
      session[:username] = username
      session[:profileImageUrl] = profile_image_url
      auto_login(@user)
      render json: { status: 'success', message: 'ログインしました' }
    else
      render json: { status: 'error', message: 'ログインに失敗しました' }, status: :unauthorized
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "ログアウトしました"
  end

end