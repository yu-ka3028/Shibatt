Rails.application.config.sorcery.submodules = [:external]

Rails.application.config.sorcery.configure do |config|
  config.user_config do |user|
    user.stretches = 1 if Rails.env.test?
  end
  config.user_class = "User"

  # -- external --
  config.external_providers = %i[line]

  config.line.key = Rails.application.credentials.dig(:line, :channel_id)
  config.line.secret = Rails.application.credentials.dig(:line, :channel_secret)
  config.line.callback_url = 'http://localhost:3000/oauth/callback?provider=line'
  config.line.scope = 'profile'
  config.line.user_info_mapping = {name: 'displayName', email: 'userId'}

  config.user_config do |user|
    user.authentications_class = Authentication
  end
  
  config.line.authorize_url = 'https://access.line.me/oauth2/v2.1/authorize?response_type=code&scope=profile&client_id=' + config.line.key + '&redirect_uri=' + config.line.callback_url + '&state=' + SecureRandom.hex(8) + '&display=page'
  
  # 開発環境
  config.line.callback_url = 'https://shibatt-dcf5dffc0d02.herokuapp.com/oauth/callback?provider=line'

  # テスト環境
  # config.line.callback_url = 'http://localhost:3000/oauth/callback?provider=line'
  
end
