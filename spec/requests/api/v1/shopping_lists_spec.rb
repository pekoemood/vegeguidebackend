require 'rails_helper'

RSpec.describe "Api::V1::ShoppingLists", type: :request do
  describe "GET /api/v1/shopping_lists" do
    it "ショッピングリスト一覧を取得できる" do
      user = create(:user) # userを作成
      create(:shopping_list, user: user)
      login user # ログイン

      get api_v1_shopping_lists_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/v1/shopping_Lists/:id' do
    it '指定のショッピングリストを取得できる' do
      user = create(:user) # userを作成
      list = create(:shopping_list, user: user)
      login user # ログイン

      get api_v1_shopping_list_path(list)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /api/v1/shopping_lists' do
    let!(:user) { create(:user) }
    before { login user }

    context '正常系' do
      it 'リクエストしたショッピングリストを作成できる' do
        params = { name: 'テスト' }

        post api_v1_shopping_lists_path, params: params
        expect(response).to have_http_status(:created)
      end
    end

    context '異常系' do
      it 'リクエストデータに不備がある場合、unprocessable_entityが返る' do
        params = { name: nil }

        post api_v1_shopping_lists_path, params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it '作成したリストがInvalidの場合、unprocessable_entityが返る' do
        # shopping_list = ShoppingList.new(name: nil)
        # user.shopping_lists.build(name: nil)

        invalid_list = build(:shopping_list, name: nil)

        allow_any_instance_of(User).to receive_message_chain(:shopping_lists, :new).and_return(invalid_list)
        
        post "/api/v1/shopping_lists", params: { name: 'test' }
        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON(response.body)
        expect(json['status']).to eq('failed')
        # expect(shopping_list).to be_invalid
      end
    end
    


  end

  describe 'DELETE /api/v1/shopping_lists/:id' do
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
      it 'レシピからショッピングリストが作成される' do
        post "/api/v1/shopping_lists/from_recipe", params: { recipe_id: recipe.id, shopping_list_id: shopping_list.id, name: 'test' }
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['name']).to eq('test')

        
      end
    end
  end
end 