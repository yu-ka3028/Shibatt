class ReflectionMemo < ApplicationRecord
  after_create :FB_to_line

  belongs_to :user
  has_many :reflection_memo_memos
  has_many :memos, through: :reflection_memo_memos
  

  validates :content, presence: true, length: { maximum: 255 }
  
  after_save :update_memo_progress

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "progress", "memo_ids"]
  end

  def FB_to_line
    chatgpt_message = ChatgptService.call(self.content)

    message = {
      type: 'text',
      text: "振り返りメモにShibaからフィードバックが届いています:\n 📝#{self.content}\n****************************\n《Shibaからのフィードバック💌》: \n#{chatgpt_message}"
    }

    # LINEにメッセージを送信
    LinebotController.new.client.push_message(self.user.line_user_id, message)
  end

  private

  def update_memo_progress
    memos.update_all(progress: true)
  end

end
