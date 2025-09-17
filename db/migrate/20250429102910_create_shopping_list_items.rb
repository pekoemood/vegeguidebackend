class CreateShoppingListItems < ActiveRecord::Migration[7.2]
  def change
    create_table :shopping_list_items do |t|
      t.references :shopping_list, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.boolean :checked, default: false

      t.timestamps
    end
    add_index :shopping_list_items, [:shopping_list_id, :ingredient_id], unique: true
  end
end
