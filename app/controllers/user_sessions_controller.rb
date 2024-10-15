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

  # def create_from_line
  #   provider = params[:provider]
  #   user_hash = fetch_user_hash_from_provider(provider)
  
  #   @user = User.create!(username: user_hash[:displayName], line_user_id: user_hash[:userId])
  
  #   if @user.persisted?
  #     reset_session
  #     auto_login(@user)
  #     redirect_to root_path, notice: "#{provider.titleize}からログインしました!"
  #   else
  #     puts "Failed to login from #{provider}"
  #     redirect_to root_path, alert: "#{provider.titleize}からのログインに成功しました!!"
  #   end
  # end

  def create_from_liff
    username = params[:user_session][:username]
    line_user_id = params[:user_session][:line_user_id]
    profile_image_url = params[:user_session][:profileImageUrl]
    
    @user = User.find_by(line_user_id: line_user_id)
    
    if @user
      @user.authentications.find_or_create_by(line_user_id: line_user_id, provider: 'line')
    else
      if User.exists?(line_user_id: line_user_id)
        render json: { status: 'error', message: 'LINEユーザーIDが既に存在します' }, status: :unprocessable_entity
        return
      end
      @user = User.new(username: username, line_user_id: line_user_id)
      @user.save(validate: false)
      @user.authentications.create(line_user_id: line_user_id, provider: 'line') if @user.persisted?
    end
    if @user.persisted?
      session[:username] = username
      session[:profileImageUrl] = profile_image_url
      auto_login(@user)
      render json: { status: 'success', message: 'ログインしました' }
    else
      puts @user.errors.full_messages
      render json: { status: 'error', message: 'ログインに失敗しました' }, status: :unauthorized
    end
  end

  def destroy
    logout
    render json: { status: 'success', message: 'ログアウトしました' }
    # redirect_to root_path, notice: "ログアウトしました"
  end

end

private

def fetch_user_hash_from_provider(provider)
  auth_hash = request.env['omniauth.auth']
  user_hash = {
    displayName: auth_hash['info']['name'],
    userId: auth_hash['uid']
  }

  Rails.logger.info("取得したユーザー情報: #{user_hash}")

  user_hash
end