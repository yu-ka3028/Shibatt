class Memo < ApplicationRecord
  paginates_per 5
  belongs_to :user
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
  
end
