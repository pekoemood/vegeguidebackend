require 'rails_helper'

RSpec.describe "Api::V1::Auth", type: :request do
  describe "POST /api/v1/auth/google_login" do
    context '正常系' do
      let!(:user) { create(:user) }
      let!(:params) {{ code: 'auth_code' }}
      it '正しいレスポンスが帰ること' do
        double = instance_double(GoogleAuthService)
        google_response = { success: user }
        allow(GoogleAuthService).to receive(:new).and_return(double)
        allow(double).to receive(:authenticate!).and_return(google_response)
        post "/api/v1/auth/google_login", params: params
        expect(response).to have_http_status(:ok)
        
      end
    end
  end
end
