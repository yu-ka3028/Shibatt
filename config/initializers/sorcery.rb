Rails.application.config.sorcery.submodules = [:external]

Rails.application.config.sorcery.configure do |config|
  config.user_config do |user|
    user.stretches = 1 if Rails.env.test?
  end
  config.user_class = "User"

  # -- external --
  config.external_providers = %i[line]

  config.line.key = ENV['LINE_CHANNEL_ID'].to_s
  config.line.secret = ENV['LINE_CHANNEL_SECRET'].to_s
  config.line.callback_url = ENV['LINE_CALLBACK_URL']
  config.line.scope = 'profile'
  config.line.user_info_mapping = {name: 'displayName', email: 'userId'}

  config.user_config do |user|
    user.authentications_class = Authentication
  end
end
