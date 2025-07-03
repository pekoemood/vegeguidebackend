require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /api/v1/users" do
    it "正常にユーザー登録できる" do
      post api_v1_users_path, params: { name: 'test', email: 'test@example.com', password: 'password' }
      expect(response).to have_http_status(:success)
      expect(response.cookies['jwt']).to be_present
      expect(JSON.parse(response.body)['status']).to eq('ユーザーの登録に成功しました')
    end

    it 'バリデーションエラー時は422が返る' do
      post api_v1_users_path, params: { name: '', email: '', password: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to be_present
    end
  end
end
