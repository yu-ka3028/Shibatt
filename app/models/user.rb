class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :username, presence: true, length: { minimum: 1 }, unless: :using_oauth?
  validates :password, length: { minimum: 4 }, if: -> { new_record? || changes[:crypted_password] }, unless: :using_oauth?
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }, unless: :using_oauth?
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }, unless: :using_oauth?

  # validates :email, uniqueness: true, allow_blank: true, unless: :using_oauth?

  has_many :memos
  has_many :reflection_memos

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  def using_oauth?
    authentications.present?
  end

  def progress_rate
    total_memo_count = memos.count
    completed_memo_count = memos.where(progress: true).count
    in_progress_memo_count = total_memo_count - completed_memo_count
    completed_percentage = (completed_memo_count.to_f / total_memo_count * 100).round(2)
    in_progress_percentage = (in_progress_memo_count.to_f / total_memo_count * 100).round(2)
  
    { completed: completed_percentage, in_progress: in_progress_percentage }
  end

  def self.create_from(user_hash, provider)
    Rails.logger.debug("User hash: #{user_hash.inspect}")
    return nil if user_hash.nil?
  
    username = user_hash[:displayName] || "user_#{SecureRandom.hex(4)}"
    
    user = User.new(
      username: username,
      password: SecureRandom.hex(16)
    )
  
    if user.save
      user.authentications.create(provider: provider, uid: user_hash[:userId])
    else
      
    end
  
    user
  end

  def self.create_from(provider)
    user_hash = sorcery_fetch_user_hash(provider)
    Rails.logger.debug("User hash: #{user_hash.inspect}")
    @user = User.create_from(user_hash, provider)
    @user || raise("Failed to create user from #{provider}")
  end

end
