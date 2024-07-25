class Memo < ApplicationRecord
  paginates_per 5
  belongs_to :user
  has_many :reflection_memo_memos
  has_many :reflection_memos, through: :reflection_memo_memos

  validates :content, presence: true, length: { maximum: 5 }

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "progress"]
  end
  
end
