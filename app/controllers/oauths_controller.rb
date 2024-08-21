class OauthsController < ApplicationController
  include Sorcery::Controller
  skip_before_action :require_login, raise: false

  def oauth
    login_at(auth_params[:provider])
    puts auth_params[:provider]
  end

  def callback
    provider = params[:provider]
    Rails.logger.debug("Provider: #{provider}")
    
    if @user = login_from(provider)
      Rails.logger.debug("Existing user logged in: #{@user.inspect}")
      redirect_to root_path, notice: "#{provider.titleize}からログインしました!"
    else
      begin
        @user = create_from(provider)
        Rails.logger.debug("New user created: #{@user.inspect}")
        # LINEから取得したuserIdをline_user_idに保存
        @user.update(line_user_id: @user.authentications.find_by(provider: provider).uid)
        Rails.logger.debug("Updated line_user_id: #{@user.line_user_id}")
        reset_session
        auto_login(@user)
        Rails.logger.debug("Auto login successful: #{logged_in?}")
  
        # 新規ユーザーが作成されたときに友達登録を促すメッセージを送信
        if provider == 'line'
          client = Line::Bot::Client.new { |config|
            config.channel_secret = Rails.application.credentials.dig(:linebot, :channel_secret)
            config.channel_token = Rails.application.credentials.dig(:linebot, :channel_token)
          }
          message = {
            type: 'text',
            text: "ようこそ！このbotを友達登録することで、素早くアプリへメモを作成する機能などを利用できます。"
          }
          response = client.push_message(@user.line_user_id, message)
          Rails.logger.debug("Response from LINE: #{response.inspect}")
        end
  
        redirect_to root_path, notice: "#{provider.titleize}からログインしました!"
      rescue => e
        Rails.logger.error("ユーザー作成に失敗: #{e.message}")
        Rails.logger.error(e.backtrace.join("\n"))
        redirect_to root_path, alert: "#{provider.titleize}からのログインに失敗しました!"
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :state, :error)
  end
end
