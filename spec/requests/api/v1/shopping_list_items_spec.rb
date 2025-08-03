require 'rails_helper'

RSpec.describe "Api::V1::ShoppingListItems", type: :request do
  describe "POST /api/v1/shopping_lists/:shopping_list_id/shopping_list_items" do
    let(:user) { create(:user) }
    let(:shopping_list) { create(:shopping_list, user: user) }
    let(:new_item_params) do { name: 'トマト', display_amount: 1, category: '野菜' } end

    context '認証されたユーザーの場合' do
      before do
        login user
      end

      it 'ショッピングリストアイテムを追加し、成功レスポンスを返すこと' do
        expect {
          post "/api/v1/shopping_lists/#{shopping_list.id}/shopping_list_items", params: new_item_params
        }.to change(ShoppingListItem, :count).by(1)
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('success')
        expect(json['message']).to eq('ショッピングアイテムの追加に成功しました')
        expect(json['item']['name']).to eq('トマト')
        expect(json['item']['display_amount']).to eq('1')
        expect(json['item']).to have_key('item_id')
      end

      it 'ショッピングリストがない場合は、エラーを返す' do
        not_existent_id = 9999
        expect {
          post "/api/v1/shopping_lists/#{not_existent_id}/shopping_list_items", params:  new_item_params
        }.to_not change(ShoppingListItem, :count)
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('failed')
        expect(json['message']).to eq('買い物リストが見つかりませんでした')
      end

      it 'リクエスト情報が不十分な場合はエラーがを返す' do
        invalid_params = { name: nil, display_amount: nil, category: nil }
        expect {
          post "/api/v1/shopping_lists/#{shopping_list.id}/shopping_list_items", params: invalid_params
        }.to_not change(ShoppingListItem, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('材料の作成に失敗しました')
      end
    end

    context '認証されていないユーザーの場合' do
      it 'ショッピングリストにアイテムを追加できない' do
        expect {
          post "/api/v1/shopping_lists/#{shopping_list.id}/shopping_list_items", params: new_item_params
        }.to_not change(ShoppingListItem, :count)
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('ログインしてください')
      end
    end
  end
  
  describe 'PATCH /api/v1/shopping_list_items/:id' do
    let(:user) { create(:user) }
    let(:shopping_list) { create(:shopping_list, user: user) }
    let(:ingredient) { create(:ingredient) }
    let(:shopping_list_item) { create(:shopping_list_item, shopping_list: shopping_list, ingredient: ingredient )}
    let(:checked_params) do { checked: true } end
    before do
      login user
    end

    context '正常系' do
      it 'アイテムの更新ができること' do
        patch "/api/v1/shopping_list_items/#{shopping_list_item.id}", params: checked_params
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('success')
        expect(json['message']).to eq('アイテムの更新に成功しました')
        expect(shopping_list_item.reload.checked).to eq(true)
      end
    end

    context '異常系' do
      it '存在しないアイテムの更新はできないこと' do
        invalid_id = 9999
        patch "/api/v1/shopping_list_items/#{invalid_id}", params: checked_params
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('failed')
        expect(json['message']).to eq('当該のアイテムが見つかりませんでした')
      end
    end
  end
end
