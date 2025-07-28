require 'rails_helper'

RSpec.describe "Api::V1::Recipes", type: :request do
  describe 'GET /api/v1/recipes' do
    context '認証済みのユーザーの場合' do
      let!(:user) { create(:user) }
      let!(:recipe) { create_list(:recipe, 3, user: user) }
      # let!(:ingredients) { create(:ingredient, recipe: recipe) }
      # let!(:recipe_step) { create(:recipe_step, recipe: recipe) }
      it 'ユーザーのレシピ一覧を取得できること' do
        login user
        get api_v1_recipes_path
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json['data'].length).to eq 3
      end
    end

    context '認証されていないユーザーの場合' do
      let(:recipe) { create(:recipe) }
      it '401エラーを返すこと' do
        get api_v1_recipes_path
        expect(response).to have_http_status '401'
        json = JSON.parse(response.body)
        expect(json['status']).to eq 'ログインしてください'
      end
    end
  end

  describe 'GET /api/recipes/:id' do
    let!(:user) { create(:user) }
    let!(:recipe) { create(:recipe, name: 'new_recipe', user: user) }
    
    it '指定したレシピが返されること' do
      login user
      get api_v1_recipe_path(id: recipe.id)
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['name']).to eq 'new_recipe'
    end
  end
end
