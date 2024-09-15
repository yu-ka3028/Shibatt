module FlexMessage
  class HelpMessage
    def content
      {
        "type": "carousel",
        "contents": [
          {
            "type": "bubble",
            "size": "micro",
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "使い方",
                  "weight": "bold",
                  "size": "lg",
                  "wrap": true
                },
                {
                  "type": "separator"
                },
                {
                  "type": "image",
                  "url": "https://i.gyazo.com/0cebf36a6ea53d799f10bdfe3b485a23.png",
                  "size": "xl",
                  "backgroundColor": "#F0EAAC"
                },
                {
                  "type": "separator"
                },
                {
                  "type": "text",
                  "text": "・ログイン",
                  "size": "sm"
                },
                {
                  "type": "text",
                  "text": "・メモ作成",
                  "size": "sm"
                },
                {
                  "type": "text",
                  "text": "・振り返りメモ作成",
                  "size": "sm"
                },
                {
                  "type": "text",
                  "text": "・その他",
                  "size": "sm"
                },
                {
                  "type": "button",
                  "action": {
                    "type": "uri",
                    "label": "説明を見る",
                    "uri": "http://linecorp.com/"
                  },
                  "margin": "sm",
                  "style": "primary"
                }
              ],
              "spacing": "sm",
              "paddingAll": "13px"
            }
          },
          {
            "type": "bubble",
            "size": "micro",
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "お問い合わせ",
                  "weight": "bold",
                  "size": "lg"
                },
                {
                  "type": "separator"
                },
                {
                  "type": "image",
                  "url": "https://i.gyazo.com/f7a194f602a84abcd8c556a45a3ff101.png",
                  "backgroundColor": "#CCE0AC",
                  "size": "xl",
                  "margin": "sm"
                },
                {
                  "type": "separator",
                  "margin": "sm"
                },
                {
                  "type": "text",
                  "text": "・不具合",
                  "size": "sm",
                  "margin": "lg",
                  "align": "start"
                },
                {
                  "type": "text",
                  "text": "・ご意見",
                  "size": "sm"
                },
                {
                  "type": "text",
                  "text": "・その他",
                  "size": "sm"
                },
                {
                  "type": "button",
                  "action": {
                    "type": "uri",
                    "label": "GoogleForm",
                    "uri": "https://forms.gle/e3kzULyof6uYDSus7"
                  },
                  "margin": "lg",
                  "style": "primary",
                  "position": "relative",
                  "gravity": "bottom",
                  "offsetEnd": "none",
                  "offsetTop": "md"
                }
              ],
              "spacing": "sm",
              "paddingAll": "13px"
            }
          },
          {
            "type": "bubble",
            "size": "micro",
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "開発者Profile",
                  "weight": "bold",
                  "size": "lg"
                },
                {
                  "type": "separator"
                },
                {
                  "type": "image",
                  "url": "https://i.gyazo.com/cb75cc12982648766a661d8ffb712ce3.png",
                  "margin": "sm",
                  "size": "xl"
                },
                {
                  "type": "separator"
                },
                {
                  "type": "text",
                  "text": "・X",
                  "margin": "lg",
                  "size": "xs"
                },
                {
                  "type": "text",
                  "text": "・GitHub",
                  "size": "xs"
                },
                {
                  "type": "text",
                  "text": "・開発アプリ",
                  "size": "xs"
                },
                {
                  "type": "text",
                  "text": "・Zenn",
                  "size": "xs"
                },
                {
                  "type": "button",
                  "action": {
                    "type": "uri",
                    "label": "ポートフォリオ",
                    "uri": "https://school.runteq.jp/social_portfolios/yuuka_shiba8"
                  },
                  "margin": "sm",
                  "style": "primary"
                }
              ],
              "spacing": "sm",
              "paddingAll": "13px"
            }
          }
        ]
      }
    end
  end
end
