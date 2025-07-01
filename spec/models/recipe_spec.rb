require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'バリデーション' do
    it '有効なレシピであれば保存できる' do
      recipe = build(:recipe)
      expect(recipe).to be_valid
      puts "#{recipe.user.inspect}"
    end
  end
end