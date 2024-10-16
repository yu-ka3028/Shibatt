class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

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
    
    def get_update_username_and_profile_image_url_from_line_api(uid)
      uri = URI.parse("https://api.line.me/v2/bot/profile/#{uid}")
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