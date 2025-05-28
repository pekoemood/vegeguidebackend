class AddDisplayAmountToFridgeItems < ActiveRecord::Migration[7.2]
  def change
    add_column :fridge_items, :display_amount, :string
  end
end
