class CreateMemos < ActiveRecord::Migration[7.1]
  def change
    create_table :memos do |t|
      t.references :user, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
