class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    puts "oauth/params"
    pp params
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    if @user = login_from(provider)
      redirect_to root_path, :notice => "Logged in from #{provider.titleize}!"
    else
      @user = create_from(provider)
      # NOTE: this is the place to add '@user.activate!' if you are using user_activation submodule
      reset_session # protect from session fixation attack
      auto_login(@user)
      redirect_to root_path, :notice => "Logged in from #{provider.titleize}!"
    
      redirect_to root_path, :alert => "Failed to login from #{provider.titleize}!"
    end
  end

  private

  def process_callback_for(provider)
    @user = create_from(provider)
    reset_session
    auto_login(@user)

    send_welcome_message if provider == 'line'

    redirect_to root_path, notice: "#{provider.titleize}からログインしました!"
  rescue => e
    Rails.logger.error "Failed to login from #{provider}: #{e.message}"
    redirect_to root_path, alert: "#{provider.titleize}からのログインに失敗しました!"
  end

  def send_welcome_message
    client = Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.dig(:linebot, :channel_secret)
      config.channel_token = Rails.application.credentials.dig(:linebot, :channel_token)
    }
    message = {
      type: 'text',
      text: "ようこそ！このbotを友達登録することで、素早くアプリへメモを作成する機能などを利用できます。"
    }
    client.push_message(@user.uid, message)
  end

  def auth_params
    params.permit(:code, :provider, :state, :error)
  end
end
