class AddPaidToActions < ActiveRecord::Migration[5.2]
  def change
    add_column :auctions, :paid, :boolean, default: false
  end
end
