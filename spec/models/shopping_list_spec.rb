require 'rails_helper'

RSpec.describe ShoppingList, type: :model do
  describe 'バリデーション' do
    it '正常な値であれば保存される' do
      shopping_list = create(:shopping_list)
      expect(shopping_list).to be_valid
    end

    it 'user_idがないと保存されない' do
      shopping_list = build(:shopping_list, user: nil)
      expect(shopping_list).not_to be_valid
      expect(shopping_list.errors[:user]).to include('must exist')
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should have_many(:shopping_list_items).dependent(:destroy) }
    it { should have_many(:recipes).through(:shopping_list_items) }
    it { should have_many(:ingredients).through(:shopping_list_items) }

    it 'userと関連付けができる' do
      user = create(:user)
      shopping_list = create(:shopping_list, user: user)
      expect(shopping_list.user).to eq(user)
    end

    it 'shopping_list_itemsと関連づけができる' do
      list = create(:shopping_list)
      item1 = create(:shopping_list_item, shopping_list: list)
      item2 = create(:shopping_list_item, shopping_list: list)
      expect(list.shopping_list_items).to include(item1, item2)
      expect(list.shopping_list_items.count).to eq(2)
      expect { list.destroy }.to change { ShoppingListItem.count }.by(-2)
    end

    it 'recipeと関連付けができる' do
      list = create(:shopping_list)
      recipe1 = create(:recipe)
      recipe2 = create(:recipe)
      create(:shopping_list_item, shopping_list: list, recipe: recipe1)
      create(:shopping_list_item, shopping_list: list, recipe: recipe2)
      expect(list.recipes).to include(recipe1, recipe2)
    end

    it 'ingredientsと関連付けができる' do
      ingredient1 = create(:ingredient)
      ingredient2 = create(:ingredient)
      list = create(:shopping_list)
      create(:shopping_list_item, shopping_list: list, ingredient: ingredient1)
      create(:shopping_list_item, shopping_list: list, ingredient: ingredient2)
      expect(list.ingredients).to include(ingredient1, ingredient2)
    end
  end

  describe '#updated_days_ago' do
    it '更新が当日であれば今日がかえされる' do
      list = create(:shopping_list)
      create(:shopping_list_item, shopping_list: list, created_at: Date.today)
      expect(list.updated_days_ago).to eq('今日')
    end

    it '更新が2日前であれば2日前とかえされる' do
      list = create(:shopping_list)
      create(:shopping_list_item, shopping_list: list, created_at: 2.days.ago)
      expect(list.updated_days_ago).to eq('2日前')
    end
  end
end
