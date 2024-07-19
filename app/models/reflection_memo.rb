class ReflectionMemo < ApplicationRecord
  belongs_to :user
  has_many :reflection_memo_memos
  has_many :memos, through: :reflection_memo_memos

  validates :content, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "progress", "memo_ids"]
  end
end
