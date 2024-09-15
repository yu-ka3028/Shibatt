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
          line_user_id = event['source']['userId']
          user = User.find_by(line_user_id: line_user_id)
          if event.message['text'] == '達成率'
            # ProgressMessageクラスのインスタンスを作成
            progress_message = FlexMessage::ProgressMessage.new(user.memos)

            message = {
              type: 'flex',
              altText: '達成率',
              # インスタンスからcontentsメソッドを呼び出す
              contents: progress_message.contents
            }
          elsif event.message['text'] == '困ったとき'
            # "困ったとき"の応答を取得するAPIを呼び出す
            response = Net::HTTP.get(URI('http://example.com/api/v1/responses?keyword=困ったとき'))
            response_data = JSON.parse(response)
          
            # 取得した応答をリッチメッセージとして送信
            message = {
              type: 'flex',
              altText: '困ったときの対処法',
              contents: response_data['contents']
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
            # ユーザーが未登録の場合、新規登録を促すメッセージを送信
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
