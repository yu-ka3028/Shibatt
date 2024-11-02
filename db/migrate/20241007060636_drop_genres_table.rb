class DropGenresTable < ActiveRecord::Migration[7.0]
  def up
    # テーブルが存在する場合のみ削除
    if table_exists?(:genres)
      drop_table :genres
    end
  end

  def down
    # ロールバック時の処理（必要な場合）
  end
end