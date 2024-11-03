class RemoveLineUserIdFromAuthentications < ActiveRecord::Migration[7.1]
  def change
    remove_column :authentications, :line_user_id, :string if column_exists?(:authentications, :line_user_id)
  end
end