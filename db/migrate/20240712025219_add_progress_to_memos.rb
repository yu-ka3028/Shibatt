class AddProgressToMemos < ActiveRecord::Migration[7.1]
  def change
    add_column :memos, :progress, :boolean, default: false
  end
end
