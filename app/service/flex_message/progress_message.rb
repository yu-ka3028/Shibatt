module FlexMessage
  class ProgressMessage
    def initialize(memos)
      @memos = memos
    end
    def progress_rate(period = :all)
      case period
      when :all
        memos = @memos
      when :month
        memos = @memos.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)
      when :week
        memos = @memos.where(created_at: 1.week.ago.beginning_of_day..Time.now.end_of_day)
      end
    
      total = memos.count
      in_progress = memos.where(progress: 'in progress').count
      completed = memos.where(progress: 'completed').count
    
      in_progress_rate = (in_progress.to_f / total * 100).round(2)
      completed_rate = (completed.to_f / total * 100).round(2)
    
      { in_progress: in_progress_rate, completed: completed_rate }
    end
    def contents
      rates = progress_rate(:all) # 全体の進行状況
      month_rates = progress_rate(:month) # 月間の進行状況
      week_rates = progress_rate(:week) # 週間の進行状況
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
                  "text": "#{rates[:completed]}%", # 達成率(全体)
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
              "backgroundColor": "#524C42",
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
                    # {
                    #   "type": "text",
                    #   "text": "",
                    #   "color": "#8C8C8C",
                    #   "size": "sm",
                    #   "wrap": true
                    # }
                  ],
                  "flex": 1
                }
              ],
              "spacing": "md",
              "paddingAll": "12px",
              "backgroundColor": "#524C42",
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
                  "text": "#{Time.now.month}月",
                  "color": "#ffffff",
                  "align": "start",
                  "size": "md",
  
                  "gravity": "center"
                },
                {
                  "type": "text",
                  "text": "#{month_rates[:completed]}%", # 達成率(当月)
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
              "backgroundColor": "#E2DFD0",
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
                    # {
                    #   "type": "text",
                    #   "text": "",
                    #   "color": "#8C8C8C",
                    #   "size": "sm",
                    #   "wrap": true
                    # }
                  ],
                  "flex": 1
                }
              ],
              "spacing": "md",
              "paddingAll": "12px",
              "backgroundColor": "#E2DFD0",
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
                  "text": "#{week_rates[:completed]}%", # 達成率(先週)
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
                      "backgroundColor": "#Fffffff",
                      "height": "6px"
                    }
                  ],
                  "backgroundColor": "#9FD8E36E",
                  "height": "6px",
                  "margin": "sm"
                }
              ],
              "backgroundColor": "#F97300",
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
              "uri": "https://liff.line.me/2006024454-QgjEWevp"
              # "uri": "https://shibatt-dcf5dffc0d02.herokuapp.com/reflection_memos/new?user_id=${userId}"
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
