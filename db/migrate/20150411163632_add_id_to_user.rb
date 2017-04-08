class AddIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :number, :integer
    change_column :users, :number, :integer, null: false
    add_index :users, :number, unique: true
  end
end
