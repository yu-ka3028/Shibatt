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
        reset_session
        auto_login(@user)
        Rails.logger.debug("Auto login successful: #{logged_in?}")
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
