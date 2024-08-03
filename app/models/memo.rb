class Memo < ApplicationRecord
  paginates_per 5
  belongs_to :user
  has_many :memo_tags
  has_many :tags, through: :memo_tags
  has_many :reflection_memo_memos
  has_many :reflection_memos, through: :reflection_memo_memos

  validates :content, presence: true, length: { maximum: 5 }

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "progress"]
  end

  def progress_rate
    total = memos.count
    in_progress = memos.where(progress: 'in progress').count
    completed = memos.where(progress: 'completed').count
  
    in_progress_rate = (in_progress.to_f / total * 100).round(2)
    completed_rate = (completed.to_f / total * 100).round(2)
  
    { in_progress: in_progress_rate, completed: completed_rate }
  end
  
  def memo_tags(tags)
    current_tags = self.tags.pluck(:name)
    tags = tags.split(',') if tags.is_a?(String)
  
    tags.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name.strip)
      self.tags << tag unless self.tags.include?(tag)
    end
  
    tags_to_delete = current_tags - tags
    self.tags.where(name: tags_to_delete).destroy_all
  end

  def tag_names
    self.tags.map(&:name).join(', ')
  end

  def self.tag_search(tag_name)
    joins(:tags).where(tags: { name: tag_name })
  end
end
