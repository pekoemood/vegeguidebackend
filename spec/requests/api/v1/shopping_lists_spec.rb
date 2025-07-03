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
    it 'リクエストしたショッピングリストを作成できる' do
      user = create(:user)
      params = { name: 'テスト' }
      login user

      puts params.inspect

      post api_v1_shopping_lists_path, params: params
      expect(response).to have_http_status(:created)
    end

    it 'リクエストデータに不備がある場合' do
      user = create(:user)
      params = { name: nil }
      login user

      post api_v1_shopping_lists_path, params: params
      expect(response).to have_http_status(:unprocessable_entity)
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
end