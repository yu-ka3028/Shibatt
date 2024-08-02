class CreateMemoTags < ActiveRecord::Migration[7.1]
  def change
    create_table :memo_tags do |t|

      t.timestamps
    end
  end
end
