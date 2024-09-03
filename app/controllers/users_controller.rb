class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :create_from_line]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, notice: 'User was successfully created.'
    else
      flash.now[:alert] = 'User could not be created.'

      render :new, status: :unprocessable_entity
    end
  end

  # def create_from_line
  #   username = params[:username]
  #   profile_image_url = params[:profile_image_url]
  
  #   # ユーザー名が存在するか確認し、存在しない場合は新しいユーザーを作成
  #   @user = User.find_by(username: username) || User.new(username: username, profile_image_url: profile_image_url)
  
  #   if @user.save
  #     auto_login(@user)
  #     render json: { status: 'ok' }
  #   else
  #     render json: { status: 'error', message: 'User could not be created.' }, status: :unprocessable_entity
  #   end
  # end
  
  def create_from_line
    username = params[:username]
    profile_image_url = params[:profile_image_url]
  
    @user = User.find_by(username: username)
    if @user
      auto_login(@user)
      render json: { status: 'ok' }
    else
      @user = User.new(username: username, profile_image_url: profile_image_url)
      if @user.save
        auto_login(@user)
        render json: { status: 'ok' }
      else
        render json: { status: 'error', message: 'User could not be created.' }, status: :unprocessable_entity
      end
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
