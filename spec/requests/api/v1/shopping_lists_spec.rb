require 'rails_helper'

RSpec.describe "Api::V1::ShoppingLists", type: :request do
  describe "GET /api/v1/shopping_lists" do
    it "ショッピングリスト一覧を取得できる" do
      user = create(:user)
      create(:shopping_list, user: user)
      login user

      get api_v1_shopping_lists_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET/api/v1/shopping_Lists/:id' do
    it '指定のショッピングリストを取得できる' do
      user = create(:user)
      list = create(:shopping_list, user: user)
      login user

      get api_v1_shopping_list_path(list)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST/api/v1/shopping_lists' do
    context '正常系' do
      it 'リクエストしたショッピングリストを作成できる' do
        user = create(:user)
        params = { name: 'テスト' }
        login user
  
        puts params.inspect
  
        post api_v1_shopping_lists_path, params: params
        expect(response).to have_http_status(:created)
      end
    end

    context '異常系' do
      it 'リクエストデータに不備がある場合' do
        user = create(:user)
        params = { name: nil }
        login user
  
        post api_v1_shopping_lists_path, params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it '作成したリストがInvalidの場合' do
        user = create(:user)
        recipe = create(:recipe, name: nil)
        login user

        invalid_list = build(:shopping_list, name: nil)

        allow_any_instance_of(User).to receive_message_chain(:shopping_lists, :new).and_return(invalid_list)
        

        post "/api/v1/shopping_lists", params: { name: 'test' }
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON(response.body)
        expect(json['status']).to eq('failed')
      end
    end
    


  end

  describe 'DELETE/api/v1/shopping_lists' do
    it 'リクエストするとショッピングリストを削除できる' do
      user = create(:user)
      list = create(:shopping_list, user: user)
      login user

      delete api_v1_shopping_list_path(list)
      expect(response).to have_http_status(:ok)
    end

    it 'リクエストしたリストがない場合' do
      user = create(:user)
      login user

      delete api_v1_shopping_list_path(id: 9999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST/api/v1/shopping_lists/from_recipe' do
    let!(:user) { create(:user) }
    let!(:recipe) { create(:recipe, user: user) }
    let!(:ingredient) { create(:ingredient) }
    let!(:shopping_list) { create(:shopping_list, user: user) }
    let!(:shopping_list_item) { create(:shopping_list_item, recipe: recipe, ingredient: ingredient) }
    context '正常系' do
      before { login user }
      it 'レシピが正しく登録される' do
        post "/api/v1/shopping_lists/from_recipe", params: { recipe_id: recipe.id, shopping_list_id: shopping_list.id, name: 'test' }
        expect(response).to have_http_status(:created)
      end
    end
  end
end