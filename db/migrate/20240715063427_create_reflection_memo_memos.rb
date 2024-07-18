class CreateReflectionMemoMemos < ActiveRecord::Migration[7.1]
  def change
    create_table :reflection_memo_memos do |t|
      t.references :reflection_memo, foreign_key: true
      t.references :memo, foreign_key: true  

      t.timestamps
    end
  end
end
