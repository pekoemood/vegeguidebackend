require 'rails_helper'

RSpec.describe "Api::V1::Vegetables", type: :request do
  let(:user) { create(:user) }
  let!(:vegetable) { create(:vegetable, :daikon) }
  let(:request) { { keyword: 'だいこん', season: 'true', discounted: 'true' } }
  let!(:season) { create(:season, vegetable: vegetable) }
  let!(:price) { create(:price, vegetable: vegetable) }
  describe "GET /api/v1/vegetables" do
    context '正常系' do
      it "野菜一覧を取得できる" do
        get api_v1_vegetables_path
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['data'].first['attributes']['name']).to eq("だいこん")
      end

      it 'クエリパラメーターによるフィルタリングができる' do
        get api_v1_vegetables_path, params: request
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /api/v1/vegetables/:id' do
    context '正常系' do
      it '指定の野菜を取得できる' do
        get "/api/v1/vegetables/#{vegetable.id}"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['data']['id'].to_i).to eq(vegetable.id)
      end
    end
  end

  describe 'GET /api/v1/vegetables/name' do
    context '正常系' do
      it '野菜名前を取得できる' do
        get "/api/v1/vegetables/names"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['names']).to eq([ 'だいこん' ])
      end
    end
  end

  describe 'GET /api/v1/vegetables/summary' do
    context '正常系' do
      before { login user }
      it '野菜のIDと名前と画像URLを取得できる' do
        get "/api/v1/vegetables/summary"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.first['id']).to eq(vegetable.id)
      end
    end
  end
end
