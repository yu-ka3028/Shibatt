class ChangeEmailInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :email, :string, null: true
  end
end

