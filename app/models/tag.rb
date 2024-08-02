class Tag < ApplicationRecord
  has_many :memo_tags
  has_many :memos, through: :memo_tags
  validates :name, presence: true, length: { maximum: 10 }
end
