class ReflectionMemo < ApplicationRecord
  belongs_to :user
  has_many :reflection_memo_memos
  has_many :memos, through: :reflection_memo_memos

  validates :content, presence: true, length: { maximum: 5 }
  after_save :update_memo_progress

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "progress", "memo_ids"]
  end

  private

  def update_memo_progress
    memos.update_all(progress: true)
  end
end
