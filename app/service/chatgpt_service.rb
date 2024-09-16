class ChatgptService
  include HTTParty

  attr_reader :api_url, :options, :model, :message
  def initialize(message, model = 'gpt-3.5-turbo')
    # 機密ファイルを呼び出している
    api_key = Rails.application.credentials.chatgpt_api_key
    @options = {
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{api_key}"
      }
    }
    @api_url = 'https://api.openai.com/v1/chat/completions'
    @model = model
    @message = message
  end

  def call
	# userからのメッセージに対し一つ回答を与える
    body = {
      model: model,
      messages: [{ role: 'user', content: message }]
    }
    response = HTTParty.post(api_url, body: body.to_json, headers: options[:headers], timeout: 100)
    raise response['error']['message'] unless response.code == 200
	# レスポンスはjson形式のため、下記の形で返答本文"content"のみを抽出する
    response['choices'][0]['message']['content']
  end

  class << self
    def call(message, model = 'gpt-3.5-turbo')
      new(message, model).call
    end
  end
end
