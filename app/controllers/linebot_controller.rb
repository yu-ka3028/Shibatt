class LinebotController < ApplicationController
  protect_from_forgery except: :callback
  skip_before_action :require_login, only: :callback
  
  def callback
    puts body = request.body.read
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          client.reply_message(event['replyToken'], message)

          user = User.find_by(line_user_id: event['source']['userId'])
          if user
            user.memos.create(content: event.message['text'])
          end
        end
      end
    end
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.dig(:linebot, :channel_secret)
      config.channel_token = Rails.application.credentials.dig(:linebot, :channel_token)
    }
  end
end
