class LinebotController < ApplicationController
  protect_from_forgery except: :callback
  skip_before_action :require_login, only: :callback
  
  def callback
    body = request.body.read
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          uid = event['source']['userId']
          user = User.joins(:authentications).find_by(authentications: { uid: uid })
          if event.message['text'] == '達成率'
            progress_message = FlexMessage::ProgressMessage.new(user.memos)

            message = {
              type: 'flex',
              altText: '達成率',
              contents: progress_message.contents
            }

          elsif event.message['text'] == '困ったとき'
            help_message = FlexMessage::HelpMessage.new

            message = {
              type: 'flex',
              altText: '困ったとき',
              contents: help_message.contents
            }

          elsif event.message['text'] == '使い方'
            how_to_use_message = FlexMessage::HowToUseMessage.new

            message = {
              type: 'flex',
              altText: '使い方',
              contents: how_to_use_message.contents
            }
            
          elsif user
            memo = user.memos.build(content: event.message['text'])
            tag = Tag.find_or_create_by(name: 'from_LINE')
            memo.tags << tag
            if memo.save
              message = {
                type: 'text',
                text: "メモを保存しました: #{event.message['text']}"
              }
            else
              message = {
                type: 'text',
                text: "メモの保存に失敗しました: #{memo.errors.full_messages.join(', ')}"
              }
            end
          else
            message = {
              type: 'text',
              text: "あなたはまだ登録されていません。以下のURLから新規登録してください。\n#{new_user_url}"
            }
          end
          
          client.reply_message(event['replyToken'], message)
        end
      end
    end
  end

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.dig(:linebot, :channel_secret)
      config.channel_token = Rails.application.credentials.dig(:linebot, :channel_token)
    }
  end
end