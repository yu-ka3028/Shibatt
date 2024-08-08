# config/initializers/sorcery.rb
require 'pp'

Rails.application.config.sorcery.submodules = [:external]

Rails.application.config.sorcery.configure do |config|
  config.user_config do |user|
    user.stretches = 1 if Rails.env.test?
  end
  config.user_class = "User"

  # -- external --
  config.external_providers = %i[line]

  config.line.key = Rails.application.credentials.dig(:line, :channel_id).to_s
  config.line.secret = Rails.application.credentials.dig(:line, :channel_secret).to_s
  config.line.callback_url = Rails.application.credentials.dig(:line, :callback_url)
  config.line.scope = 'profile'
  config.line.user_info_mapping = {name: 'displayName', email: 'userId'}

  config.user_config do |user|
    user.authentications_class = Authentication
  end

  pp Rails.application.credentials.dig(:line, :channel_id)
  pp Rails.application.credentials.dig(:line, :channel_secret)
  pp Rails.application.credentials.dig(:line, :callback_url)
  pp config.line.key
  pp config.line.callback_url
end
