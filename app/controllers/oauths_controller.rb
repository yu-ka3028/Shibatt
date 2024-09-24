class OauthsController < ApplicationController
  include Sorcery::Controller
  skip_before_action :require_login, raise: false
  require 'net/http'
  require 'uri'
  require 'json'
  require 'jwt'

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = params[:provider]
    if @user = login_from(provider)
      redirect_to root_path, notice: "#{provider.titleize}からログインしました!"
    else
      begin
        code = auth_params[:code]
        response = request_access_token_from_line(code)
        access_token = response['access_token'] # アクセストークンを取得
        user_info = get_user_info(access_token) # アクセストークンを使用してユーザー情報を取得
        line_user_id = user_info['userId'] # ユーザー情報からline_user_idを取得

        puts "---auth_params---"
        pp auth_params
        puts "---line_user_id---"
        pp line_user_id

        @user = User.find_by(line_user_id: line_user_id)
        
        if @user.nil?
          @user = create_from(provider)
          # LINEから取得したuserIdをローカルでline_user_idに保存
          @user.update(line_user_id: line_user_id)
  
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

  def get_user_info(access_token)
    uri = URI('https://api.line.me/v2/profile')
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{access_token}"
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
      http.request(req)
    }
    user_info = JSON.parse(res.body)
    line_user_id = user_info['userId']
  end

  def request_access_token_from_line(code)
    uri = URI.parse('https://api.line.me/oauth2/v2.1/token')
    req = Net::HTTP::Post.new(uri)
    req.set_form_data({
      'grant_type' => 'authorization_code',
      'code' => code,
      'redirect_uri' => "http://localhost:3000/oauth/callback?provider=line",
      'client_id' => Rails.application.credentials.dig(:line, :channel_id),
      'client_secret' => Rails.application.credentials.dig(:line, :channel_secret)
    })
  
    req_options = {
      use_ssl: uri.scheme == 'https'
    }
  
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end
  
    parsed_response = JSON.parse(res.body, symbolize_names: true)
    puts "Parsed response: #{parsed_response}"
    parsed_response
  end

  private

  def auth_params
    params.permit(:code, :provider, :state, :error)
  end
end
