class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :username, presence: true, length: { minimum: 1 }
  validates :password, length: { minimum: 4 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true

  has_many :memos
  has_many :reflection_memos

  def progress_rate
    total_memo_count = memos.count
    completed_memo_count = memos.where(progress: true).count
    (completed_memo_count.to_f / total_memo_count * 100).round(2)
  end
end
