class AddMemoIdAndTagIdToMemoTags < ActiveRecord::Migration[7.1]
  def change
    add_column :memo_tags, :memo_id, :integer
    add_column :memo_tags, :tag_id, :integer
  end
end
