class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    reset_session
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    begin
      if @user = login_from(provider)
        redirect_to root_path, notice: "#{provider.titleize}でログインしました"
        return
      end
  
      @user = create_from(provider)
      authentication = @user.authentications.first

      @user.assign_attributes(
        provider: authentication.provider,
        uid: authentication.uid
      )
  
      if @user.save
        Rails.logger.info "User saved successfully: #{@user.attributes.inspect}"
        reset_session
        auto_login(@user)
        send_welcome_message if provider == 'line'
        redirect_to root_path, notice: "#{provider.titleize}でアカウントを作成しました"
      else
        Rails.logger.error "User save failed: #{@user.errors.full_messages}"
        redirect_to root_path, alert: "アカウント作成に失敗しました"
      end
  
    rescue => e
      Rails.logger.error "OAuth Error: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      redirect_to root_path, alert: "認証に失敗しました。しばらく時間をおいて再度お試しください。"
    end
  end

  private

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
  rescue => e
    Rails.logger.error "Failed to send welcome message: #{e.message}"
  end

  def auth_params
    params.permit(:code, :provider, :state, :error)
  end
end