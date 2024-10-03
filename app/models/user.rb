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
    validates :password, length: { minimum: 4 }, if: -> { new_record? || changes[:crypted_password] }
    validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
    validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
    validates :email, uniqueness: true, allow_blank: true, unless: :using_oauth?
  end
  def using_oauth?
    authentications.present?
  end

  # OAuth認証で取得したユーザ情報をもとにローカルへユーザを新規作成
  def self.create_from(provider)
    user_hash = sorcery_fetch_user_hash(provider)
  
    return nil if user_hash.nil?
    username = user_hash[:displayName] || "user_#{SecureRandom.hex(4)}"
  
    user = User.find_or_create_by(username: username)
  
    if user.persisted?
      user.authentications.find_or_create_by(provider: provider, line_user_id: user_hash[:userId])
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

  private

  def add_default_data
    memo_data = [
    ]

    # seedでデフォルトメモの作成
    memos = memo_data.map do |data|
      Memo.create!(
        user_id: self.id,
        content: data[:content],
        created_at: data[:created_at],
        progress: false
      )
    end

    reflection_memo_data = [
    ]

    # 振り返りメモの作成とメモへの紐付け
    reflection_memos = reflection_memo_data.map do |data|
      reflection_memo = ReflectionMemo.create!(
        user_id: self.id,
        content: data[:content],
        created_at: data[:created_at],
        progress: false
      )

      # メモの作成と紐付け
      data[:memos].each do |memo_data|
        memo = Memo.create!(
          user_id: self.id,
          content: memo_data[:content],
          created_at: memo_data[:created_at],
          progress: false
        )

        # ReflectionMemoとMemoの関連付け
        ReflectionMemoMemo.create!(
          reflection_memo_id: reflection_memo.id,
          memo_id: memo.id
        )
      end

      reflection_memo
    end
  end