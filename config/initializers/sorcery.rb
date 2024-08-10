Rails.application.config.sorcery.submodules = [:external]
Rails.application.config.sorcery.configure do |config|
  config.user_class = "User"
  config.external_providers = [:line]
  config.line.key = Rails.application.credentials.dig(:line, :channel_id)
  config.line.secret = Rails.application.credentials.dig(:line, :channel_secret)

  # 環境に応じてcallback_urlを設定
  if Rails.env.production?
    config.line.callback_url = "https://shibatt-dcf5dffc0d02.herokuapp.com/oauth/callback?provider=line"
  else
    config.line.callback_url = "http://localhost:3000/oauth/callback?provider=line"
  end

  config.user_config do |user|
    user.authentications_class = Authentication
    user.username_attribute_names = [:username]
  end
  
  config.line.user_info_mapping = { username: 'displayName' }
end
