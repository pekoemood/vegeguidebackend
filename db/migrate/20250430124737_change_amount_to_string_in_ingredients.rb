class ChangeAmountToStringInIngredients < ActiveRecord::Migration[7.2]
  def change
    change_column :ingredients, :amount, :string
  end
end
