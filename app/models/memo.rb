class Memo < ApplicationRecord
  paginates_per 5
  belongs_to :user
  has_many :memo_tags
  has_many :tags, through: :memo_tags
  has_many :reflection_memo_memos
  has_many :reflection_memos, through: :reflection_memo_memos
  
  validates :content, presence: true, length: { maximum: 255 }
  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "progress"]
  end

  def self.ransackable_associations(auth_object = nil)
    %w(tags)
  end
  
  def memo_tags=(name)
    self.tags = [Tag.where(name: name.strip).first_or_create!]
  end

  def tag_index
    self.tags.map(&:name).join(', ')
  end

  def self.tag_search(tag_name)
    joins(:tags).where(tags: { name: tag_name })
  end
end
