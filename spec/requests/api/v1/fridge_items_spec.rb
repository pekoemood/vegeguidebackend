require 'rails_helper'

RSpec.describe "Api::V1::FridgeItems", type: :request do
  let!(:user) { create(:user) }
  

  before do
    login user
  end
  describe "GET /api/v1/fridge_items" do
    it '食材一覧を取得できる' do
      create(:fridge_item, user: user, name: 'キャベツ')
      get api_v1_fridge_items_path
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data'].first['attributes']['name']).to eq('キャベツ')
    end
  end

  describe "POST api/v1/fridge_items" do
    it '食材を登録できる' do
      params = {
        fridge: [
          {
            name: 'トマト',
            category: '野菜',
            display_amount: '2個',
            amount: 2,
            unit: '個'
          }
        ]
      }
      post api_v1_fridge_items_path, params: params
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data'].first['attributes']['name']).to eq('トマト')
    end

    it 'リクエストデータに不備がある場合' do
      params = { fridge: [] }
      post api_v1_fridge_items_path, params: params.to_json
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['message']).to eq("リクエストデータに不備があります")
    end

    it '調味料を登録する場合' do
      params = {
        fridge: [
          {
            name: '塩',
            category: '調味料',
            display_amount: '少々',
            amount: nil,
            unit: '少々'
          }
        ]
      }
      post api_v1_fridge_items_path, params: params
      expect(response).to have_http_status(:ok)
    end

    it '同じアイテムを保存した場合' do
      create(:fridge_item, user: user)
      params =  { fridge: [attributes_for(:fridge_item)] }

      post api_v1_fridge_items_path, params: params
      expect(response).to have_http_status(:ok)

    end

    it 'amountが0以下の場合' do
      create(:fridge_item, user: user, amount: 0)
      params = { fridge: [ attributes_for(:fridge_item, amount: 0)]}

      post api_v1_fridge_items_path, params: params
      expect(response).to have_http_status(:ok)
    end

    it 'リクエスト情報が不十分な場合' do
      params = { fridge: [ attributes_for(:fridge_item, name: nil)]}
      post api_v1_fridge_items_path, params: params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH/api/v1/fridge_items/:id' do
    let!(:item) { create(:fridge_item, user: user) }
    it '食材の名前が更新される' do 
      params = {
        fridge: {
          name: "トマト",
          category: item.category,
          display_amount: item.display_amount,
          expire_date: item.expire_date,
        }
      }

      patch api_v1_fridge_item_path(item), params: params
      expect(response).to have_http_status(:ok)
    end

    it '無効なデータを送信したとき' do
      params = { fridge: attributes_for(:fridge_item, name: '') }
      patch api_v1_fridge_item_path(item), params: params
      expect(response).to have_http_status(:unprocessable_entity)

    end
  end

  describe 'DELETE/api/v1/fridge_items/:id' do
    let!(:item) { create(:fridge_item, user: user) }

    it '食材が削除される' do
      delete api_v1_fridge_item_path(item)
      expect(response).to have_http_status(:ok)
    end

    it '存在しないIDを指定した場合' do
      delete api_v1_fridge_item_path(id: 9999)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
