class User < ApplicationRecord
  authenticates_with_sorcery!
  after_create :add_default_data

  has_many :memos, dependent: :destroy
  has_many :reflection_memos

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

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

  # OAuth認証で取得したユーザ情報をもとにローカルへユーザを新規作成
  def self.create_from(provider)
    user_hash = sorcery_fetch_user_hash(provider)
    puts "----user_hash----"
    pp user_hash
  
    return nil if user_hash.nil?
    username = user_hash[:displayName] || "user_#{SecureRandom.hex(4)}"
    line_user_id = user_hash[:userId]
    puts "----line_user_id----"
    pp line_user_id = user_hash[:userId]
  
    auth = Authentication.find_or_initialize_by(provider: provider, uid: line_user_id)

    if auth.new_record?
      user = User.create!(username: username, email: user_hash[:userId], line_user_id: line_user_id)
      auth.user = user
      auth.save!
    else
      user = auth.user
    end
  
    if user.persisted?
      Rails.logger.info("ユーザー作成に成功: #{user.username}")
    else
      Rails.logger.error("ユーザー作成に失敗: #{user.errors.full_messages.join(", ")}")
    end
    user || raise("ユーザー作成に失敗 from #{provider}")
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
