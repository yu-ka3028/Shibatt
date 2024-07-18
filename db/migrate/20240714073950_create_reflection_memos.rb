class CreateReflectionMemos < ActiveRecord::Migration[7.1]
  def change
    create_table :reflection_memos do |t|
      t.integer :user_id
      t.text :content
      t.boolean :progress, default: false
      t.timestamps
    end
  end
end
