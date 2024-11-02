Rails.application.config.sorcery.submodules = [:external]
Rails.application.config.sorcery.configure do |config|
  config.user_class = 'User'

  config.external_providers = [:line]
  config.line.key = Rails.application.credentials.dig(:line, :channel_id)
  config.line.secret = Rails.application.credentials.dig(:line, :channel_secret) 
  config.line.callback_url = Rails.application.credentials.dig(Rails.env, :line, :callback_url)
  config.line.scope = 'profile'
  config.line.user_info_mapping = { username: 'displayName'}

  config.user_config do |user|
    user.authentications_class = Authentication
    # デフォルトであるemailを使わず、usernameを使用
    user.username_attribute_names = [:username]
    user.password_attribute_name = :password
    user.crypted_password_attribute_name = :crypted_password
    user.salt_attribute_name = :salt
  end
end  
