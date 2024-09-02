class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    if params[:idToken] # LIFFからのログインの場合
      id_token = params[:idToken]
      logger.info("Received ID token: #{id_token}")
      channel_id = "保存したチャネルIDを入れる"
      res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'), { 'id_token' => id_token, 'client_id' => channel_id })
      line_user_id = JSON.parse(res.body)['sub']
      user = User.find_by(line_user_id: line_user_id)
      if user.nil?
        user = User.create(line_id: line_user_id)
      end
      if session[:user_id] = user.id
        render json: user
      else
        flash.now[:alert] = 'User could not be created.'
        render :new, status: :unprocessable_entity
      end
    else # LIFFからのログインでない場合
      render json: { error: 'Invalid request' }, status: :bad_request
    end
  end
  
  def refresh_username
    @user = User.find(params[:id])
    update_username, update_profile_image_url = get_update_username_and_profile_image_url_from_line_api(@user.line_user_id)
    @user.update(username: update_username, profile_image_url: update_profile_image_url)
    redirect_to @user, notice: 'ユーザー名とプロフィール画像が更新されました'
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
