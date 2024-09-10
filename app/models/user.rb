class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :memos, counter_cache: true
  has_many :reflection_memos

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  with_options unless: :using_oauth? do
    validates :username, presence: true, length: { minimum: 4 }
    validates :password, length: { minimum: 4 }, if: -> { new_record? || changes[:crypted_password] }
    validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
    validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  end
  def using_oauth?
    authentications.present?
  end

  # OAuth認証で取得したユーザ情報をもとにローカルへユーザを作成
  def self.create_from(provider)
    user_hash = sorcery_fetch_user_hash(provider)
    return nil if user_hash.nil?
    username = user_hash[:displayName] || "user_#{SecureRandom.hex(4)}"
    user = User.new(
      username: username,
      password: SecureRandom.hex(16)
    )
  
    if user.save
      user.authentications.create(provider: provider, uid: user_hash[:userId])
    else
      Rails.logger.error("Failed to save user: #{user.errors.full_messages.join(", ")}")
    end
    user || raise("Failed to create user from #{provider}")
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
