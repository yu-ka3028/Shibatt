class OauthsController < ApplicationController
  include Sorcery::Controller
  skip_before_action :require_login, raise: false

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = params[:provider]
    if @user = login_from(provider)
      redirect_to root_path, notice: "#{provider.titleize}からログインしました!"
    else
      begin
        uid = auth_params[:uid]
        @user = User.find_by(line_user_id: uid)
        if @user.nil?
          @user = create_from(provider)
          # LINEから取得したuserIdをローカルでline_user_idに保存
          @user.update(line_user_id: uid)
  
          reset_session
          auto_login(@user)
  
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
          end
  
          redirect_to root_path, notice: "#{provider.titleize}からログインしました!"
        else
          raise "Failed to create user from #{provider}"
        end
      rescue => e
        puts "Failed to login from #{provider}: #{e.message}"
        redirect_to root_path, alert: "#{provider.titleize}からのログインに失敗しました!"
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :state, :error)
  end
end
