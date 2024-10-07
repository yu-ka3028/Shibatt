class DropGenresTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :genres
  end
end