class AddNameToTags < ActiveRecord::Migration[7.1]
  def change
    add_column :tags, :name, :string
  end
end
