class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :memos
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
  def self.create_from(user_hash, provider)
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
    #結果を保持
    user
  end

  def self.create_from(provider)
    user_hash = sorcery_fetch_user_hash(provider)
    @user = User.create_from(user_hash, provider)
    @user || raise("Failed to create user from #{provider}")
  end

  def progress_rate
    total_memo_count = memos.count
    completed_memo_count = memos.where(progress: true).count
    in_progress_memo_count = total_memo_count - completed_memo_count
    completed_percentage = (completed_memo_count.to_f / total_memo_count * 100).round(2)
    in_progress_percentage = (in_progress_memo_count.to_f / total_memo_count * 100).round(2)
  
    { completed: completed_percentage, in_progress: in_progress_percentage }
  end
end
