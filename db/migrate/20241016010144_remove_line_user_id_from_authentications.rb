class RemoveLineUserIdFromAuthentications < ActiveRecord::Migration[6.0]
  def change
    remove_column :authentications, :line_user_id, :string
  end
end