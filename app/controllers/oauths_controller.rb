class OauthsController < ApplicationController
  include Sorcery::Controller
  skip_before_action :require_login, raise: false

  def oauth
    login_at(auth_params[:provider])
    puts auth_params[:provider]
  end

  def callback
    provider = params[:provider]
    if @user = login_from(provider)
      
      redirect_to root_path, :notice => "Logged in from #{provider.titleize}!"
    else
      begin
        @user = login_from(provider) 
        reset_session # protect from session fixation attack
        auto_login(@user)
        redirect_to root_path, :notice => "Logged in from #{provider.titleize}!"
      rescue
        redirect_to root_path, :alert => "Failed to login from #{provider.titleize}!"
      end
    end
  end

  def create_from!(provider)
    auth = request.env['omniauth.auth']
    User.create! do |user|
      user.username = auth['info']['name']
      user.authentications.build(provider: provider, uid: auth['uid'])
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :state, :error)
  end
end
