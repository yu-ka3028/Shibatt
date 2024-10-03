class ChangeUidToAllowNullInAuthentications < ActiveRecord::Migration[7.1]
  def change
    change_column_null :authentications, :uid, true
  end
end