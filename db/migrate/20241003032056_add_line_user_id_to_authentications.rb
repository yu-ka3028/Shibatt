class AddLineUserIdToAuthentications < ActiveRecord::Migration[7.1]
  def change
    add_column :authentications, :line_user_id, :string
  end
end
