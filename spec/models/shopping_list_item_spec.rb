require 'rails_helper'

RSpec.describe ShoppingListItem, type: :model do
  describe 'アソシエーション' do
    it { should belong_to(:shopping_list) }
    it { should belong_to(:recipe).optional }
    it { should belong_to(:ingredient) }

    it 'recipeが消えても残る' do
      recipe = create(:recipe)
      item = create(:shopping_list_item, recipe: recipe)
      expect(recipe.shopping_list_items).to include(item)
      expect { recipe.destroy }.not_to change { ShoppingListItem.count }
    end
  end

  describe '#cleanup_ingredient' do
    it 'shopping_list_itemを削除時に関連したshopping_listとrecipeが無ければingredientを削除' do
      list = create(:shopping_list)
      recipe = create(:recipe)
      ingredient = create(:ingredient)
      create(:shopping_list_item, shopping_list: list, recipe: recipe, ingredient: ingredient)
      expect { recipe.destroy }.not_to change { ShoppingListItem.count }
      ingredient.reload.update(recipe: nil)
      expect(Ingredient.count).to eq 1
      expect { list.destroy }.to change { Ingredient.count }.by(-1).and change { ShoppingListItem.count }.by(-1)
    end
  end
end
