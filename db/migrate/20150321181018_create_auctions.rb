class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.integer :user_id, null: false
      t.float :value,     null: false
      t.string :name

      t.timestamps
    end
  end
end
