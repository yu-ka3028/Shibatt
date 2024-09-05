module FlexMessage
  class ProgressMessage
    def self.contents
      {
        "type": "carousel",
        "contents": [
          {
            "type": "bubble",
            "size": "nano",
            "direction": "ltr",
            "header": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "ALL",
                  "color": "#ffffff",
                  "align": "start",
                  "size": "md",
                  "gravity": "center"
                },
                {
                  "type": "text",
                  "text": "70%",
                  "color": "#ffffff",
                  "align": "start",
                  "size": "xs",
                  "gravity": "center",
                  "margin": "lg"
                },
                {
                  "type": "box",
                  "layout": "vertical",
                  "contents": [
                    {
                      "type": "box",
                      "layout": "vertical",
                      "contents": [
                        {
                          "type": "filler"
                        }
                      ],
                      "width": "70%",
                      "backgroundColor": "#0D8186",
                      "height": "6px"
                    }
                  ],
                  "backgroundColor": "#9FD8E36E",
                  "height": "6px",
                  "margin": "sm"
                }
              ],
              "backgroundColor": "#27ACB2",
              "paddingTop": "19px",
              "paddingAll": "12px",
              "paddingBottom": "16px"
            },
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "box",
                  "layout": "horizontal",
                  "contents": [
                    {
                      "type": "text",
                      "text": "これまで作ったすべてのメモのほったらかし率",
                      "color": "#8C8C8C",
                      "size": "sm",
                      "wrap": true
                    }
                  ],
                  "flex": 1
                }
              ],
              "spacing": "md",
              "paddingAll": "12px"
            },
            "styles": {
              "footer": {
                "separator": false
              }
            }
          },
          
          {
            "type": "bubble",
            "size": "nano",
            "header": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "Month",
                  "color": "#ffffff",
                  "align": "start",
                  "size": "md",
                  "gravity": "center"
                },
                {
                  "type": "text",
                  "text": "30%",
                  "color": "#ffffff",
                  "align": "start",
                  "size": "xs",
                  "gravity": "center",
                  "margin": "lg"
                },
                {
                  "type": "box",
                  "layout": "vertical",
                  "contents": [
                    {
                      "type": "box",
                      "layout": "vertical",
                      "contents": [
                        {
                          "type": "filler"
                        }
                      ],
                      "width": "30%",
                      "backgroundColor": "#DE5658",
                      "height": "6px"
                    }
                  ],
                  "backgroundColor": "#FAD2A76E",
                  "height": "6px",
                  "margin": "sm"
                }
              ],
              "backgroundColor": "#FF6B6E",
              "paddingTop": "19px",
              "paddingAll": "12px",
              "paddingBottom": "16px"
            },
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "box",
                  "layout": "horizontal",
                  "contents": [
                    {
                      "type": "text",
                      "text": "今月のほったらかし率",
                      "color": "#8C8C8C",
                      "size": "sm",
                      "wrap": true
                    }
                  ],
                  "flex": 1
                }
              ],
              "spacing": "md",
              "paddingAll": "12px"
            },
            "styles": {
              "footer": {
                "separator": false
              }
            }
          },

          {
            "type": "bubble",
            "size": "nano",
            "header": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "Week",
                  "color": "#ffffff",
                  "align": "start",
                  "size": "md",
                  "gravity": "center"
                },
                {
                  "type": "text",
                  "text": "100%",
                  "color": "#ffffff",
                  "align": "start",
                  "size": "xs",
                  "gravity": "center",
                  "margin": "lg"
                },
                {
                  "type": "box",
                  "layout": "vertical",
                  "contents": [
                    {
                      "type": "box",
                      "layout": "vertical",
                      "contents": [
                        {
                          "type": "filler"
                        }
                      ],
                      "width": "100%",
                      "backgroundColor": "#7D51E4",
                      "height": "6px"
                    }
                  ],
                  "backgroundColor": "#9FD8E36E",
                  "height": "6px",
                  "margin": "sm"
                }
              ],
              "backgroundColor": "#A17DF5",
              "paddingTop": "19px",
              "paddingAll": "12px",
              "paddingBottom": "16px"
            },
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "box",
                  "layout": "horizontal",
                  "contents": [
                    {
                      "type": "text",
                      "text": "今週分をまとめて振り返る",
                      "color": "#8C8C8C",
                      "size": "sm",
                      "wrap": true
                    }
                  ],
                  "flex": 1
                }
              ],
              "spacing": "md",
              "paddingAll": "12px"
            },
            "action": {
              "type": "uri",
              "label": "Action",
              "uri": "https://shibatt-dcf5dffc0d02.herokuapp.com/reflection_memos/new?user_id=${userId}"
            },
            "styles": {
              "footer": {
                "separator": false
              }
            }
          }
        ]
      }
    end
  end
end
