class RemoveLineUserIdFromUsers < ActiveRecord::Migration[7.0]
  def up
    # カラムが存在する場合のみ削除
    if column_exists?(:users, :line_user_id)
      remove_column :users, :line_user_id
    end
  end

  def down
    # ロールバック時の処理
    unless column_exists?(:users, :line_user_id)
      add_column :users, :line_user_id, :string
    end
  end
end