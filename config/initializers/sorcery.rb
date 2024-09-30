Rails.application.config.sorcery.submodules = [:external]
Rails.application.config.sorcery.configure do |config|
  #(本リリースで外すか検討中)Sorceryの内部認証を使用
  config.user_class = "User"
  config.user_config do |user|
    user.authentications_class = Authentication
    user.username_attribute_names = [:username]
  end

  config.external_providers = [:line]
  config.line.key = Rails.application.credentials.dig(:line, :channel_id)
  config.line.secret = Rails.application.credentials.dig(:line, :channel_secret) 
  config.line.callback_url = Rails.application.credentials.dig(Rails.env, :line, :callback_url)
  config.line.scope = 'profile'
  config.line.user_info_mapping = { username: 'displayName' email: 'userId' }
end
