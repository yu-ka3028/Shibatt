Rails.application.config.sorcery.submodules = [:external]
Rails.application.config.sorcery.configure do |config|
  config.user_class = "User"
  config.user_config do |user|
    user.authentications_class = Authentication
    user.username_attribute_names = [:username]
  end

  config.external_providers = [:line]
  config.line.key = Rails.application.credentials.dig(:line, :channel_id)
  config.line.secret = Rails.application.credentials.dig(:line, :channel_secret)
  # if Rails.env.production?
  #   config.line.callback_url = Rails.application.credentials.dig(:production, :line, :callback_url)
  # else
  #   config.line.callback_url = Rails.application.credentials.dig(:development, :line, :callback_url)
  # end  
  config.line.callback_url = Rails.application.credentials.dig(Rails.env, :line, :callback_url)
  config.line.user_info_mapping = { username: 'displayName' }
end
