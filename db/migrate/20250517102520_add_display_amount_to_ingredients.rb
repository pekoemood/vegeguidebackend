class AddDisplayAmountToIngredients < ActiveRecord::Migration[7.2]
  def change
    add_column :ingredients, :display_amount, :string
  end
end
