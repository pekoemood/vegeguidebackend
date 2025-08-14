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

  describe 'POST /api/v1/recipes' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe, user: user) }
    let(:request) {  
        { name: 'ナポリタン',
          calorie: '500',
          recipe_category: '主菜',
          cooking_method: 'フライパン',
          instructions: '美味しいナポリタン',
          cooking_time: '30',
          purpose: '普段使い',
          servings: '2',
          ingredients: [
            name: 'スパゲッティ',
            amount: '200',
            unit: 'g',
            display_amount: '200g',
            category: '麺',
          ],
          step: [
            step_number: '1',
            description: 'スパゲッティを茹でる'
          ]
    }}
    
    before { login user }
    context '正常系' do
      it 'レシピ情報を送るとレスポンスが返ること' do
        post "/api/v1/recipes", params: request
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('レシピの登録に成功しました')
      end
    end
    context '異常系' do
      it 'レシピ登録に失敗した場合にエラーレスポンスが返ること' do
        service = instance_double(RecipeCreator)
        allow(RecipeCreator).to receive(:new).and_return(service)
        invalid_record = Recipe.new
        invalid_record.errors.add(:name, "can't be blank")
        allow(service).to receive(:call).and_raise(ActiveRecord::RecordInvalid.new(invalid_record))

        post "/api/v1/recipes", params: request
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('failed')
        expect(json['message']).to include("can't be blank")
      end

      it 'レシピ登録で予期せぬエラーが発生した場合はinternal_server_errorを返すこと' do
        allow(RecipeCreator).to receive(:new).and_return(StandardError.new('class'))
        post "/api/v1/recipes", params: request
        expect(response).to have_http_status(:internal_server_error)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('failed')
        expect(json['message']).to eq('予期せぬエラーが発生しました')
      end
    end
  end

  describe 'DELETE /api/v1/recipes/:id' do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe, user: user) }
    before { login user }
    context '正常系' do
      it 'レシピが削除される' do
        delete "/api/v1/recipes/#{recipe.id}"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('レシピの削除に成功しました')
      end
    end
  end
end
