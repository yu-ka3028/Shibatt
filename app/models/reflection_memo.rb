class ReflectionMemo < ApplicationRecord
  belongs_to :user
  has_many :reflection_memo_memos
  has_many :memos, through: :reflection_memo_memos

  validates :content, presence: true
end
