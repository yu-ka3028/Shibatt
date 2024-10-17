class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  has_many :memos, dependent: :destroy
  has_many :reflection_memos

  # sorceryを使用しての新規作成
  with_options unless: :using_oauth? do
    validates :username, presence: true, length: { minimum: 1 }, uniqueness: true
    validates :password, length: { minimum: 4 }, if: :password_required?
    validates :password, confirmation: true, if: :password_required?
    validates :password_confirmation, presence: true, if: :password_required?
    validates :email, uniqueness: true, allow_blank: true, unless: :using_oauth?
  end

  def using_oauth?
    authentications.present?
  end

  def password_required?
    new_record? || changes[:crypted_password]
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
