class RemoveLineUserIdFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :line_user_id, :string
  end
end