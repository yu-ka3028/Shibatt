class UpdateLineUserIdInAuthentications < ActiveRecord::Migration[6.0]
  def change
    add_index :authentications, :line_user_id, unique: true
  end
end