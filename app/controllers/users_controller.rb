class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :create_from_line, :create_from_liff]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, notice: 'ユーザーを作成しました'
    else
      flash.now[:alert] = 'User could not be created.'

      render :new, status: :unprocessable_entity
    end
  end

  def create_from_line
    username = params[:username]
    profile_image_url = params[:profile_image_url]
    line_user_id = params[:line_user_id] # LINEのuser_idをパラメータから取得
  
    # LINEのuser_idが存在するか確認し、存在しない場合は新しいユーザーを作成
    @user = User.find_by(line_user_id: line_user_id) || User.new(username: username, profile_image_url: profile_image_url, line_user_id: line_user_id)
  
    if @user.save
      auto_login(@user)
      render json: { status: 'ok' }
    else
      render json: { status: 'error', message: '新規ユーザーの作成に失敗しました。' }, status: :unprocessable_entity
    end
  end

  def create_from_liff
    username = params[:user_session][:username]
    profile_image_url = params[:user_session][:profile_image_url]
    line_user_id = params[:user_session][:line_user_id]
  
    # LINEのuser_idが存在するか確認し、存在しない場合は新しいユーザーを作成
    @user = User.find_by(line_user_id: line_user_id) || User.new(username: username, profile_image_url: profile_image_url, line_user_id: line_user_id)
  
    if @user.save
      @user.authentications ||= @user.build_authentications
      @user.authentications.find_or_create_by!(provider: 'line', uid: line_user_id)
  
      auto_login(@user)
      render json: { status: 'ok' }
    else
      # ユーザーの保存に失敗した場合の処理を追加
      Rails.logger.error("Failed to save user: #{@user.errors.full_messages.join(", ")}")
      render json: { status: 'error', message: '新規ユーザーの作成に失敗しました。' }, status: :unprocessable_entity
    end
  end
  
  def refresh_username
    @user = User.find(params[:id])
    update_username, update_profile_image_url = get_update_username_and_profile_image_url_from_line_api(@user.line_user_id)
  
    if update_username.nil? || update_profile_image_url.nil?
      redirect_to @user, alert: 'ユーザー名またはプロフィール画像の更新に失敗しました'
    else
      @user.update(username: update_username, profile_image_url: update_profile_image_url)
      redirect_to @user, notice: 'ユーザー名とプロフィール画像が更新されました'
    end
  end

  private
    
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
    
    def get_update_username_and_profile_image_url_from_line_api(line_user_id)
      uri = URI.parse("https://api.line.me/v2/bot/profile/#{line_user_id}")
      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Bearer #{Rails.application.credentials.dig(:linebot, :channel_token)}"
    
      req_options = {
        use_ssl: uri.scheme == "https",
      }
    
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
    
      json = JSON.parse(response.body)
      [json['displayName'], json['pictureUrl']]
    end
end
