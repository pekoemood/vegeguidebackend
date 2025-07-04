require 'rails_helper'

RSpec.describe "Api::V1::Vegetables", type: :request do
  describe "GET /api/v1/vegetables" do
    context '正常系' do
      it "野菜一覧を取得できる" do
        vegetable = create(:vegetable, :daikon)
        create(:price, vegetable: vegetable)
        get api_v1_vegetables_path
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['data'].first['attributes']['name']).to eq("だいこん")
      end
    end

  end
end
