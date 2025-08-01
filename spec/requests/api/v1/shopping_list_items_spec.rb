require 'rails_helper'

RSpec.describe "Api::V1::ShoppingListItems", type: :request do
  describe "POST /api/v1/shopping_list_items" do
    let(:user) { create(:user) }
    let(:shopping_list) { create(:shopping_list, user: user) }
    let(:new_item_params) do { name: 'トマト', display_amount: 1, category: '野菜' } end

    context '認知されたユーザーの場合' do
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
    end
  end
end
