class AddTagToMemos < ActiveRecord::Migration[7.1]
  def change
    add_column :memos, :tag, :string
  end
end
