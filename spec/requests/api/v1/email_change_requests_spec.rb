require 'rails_helper'

RSpec.describe "Api::V1::EmailChangeRequests", type: :request do
  describe "POST /api/v1/email_change_requests" do
    let(:user) { create(:user) }
    let(:new_email_params) { { new_email: 'new_email@example.com', password: 'password' } }
    let(:invalid_params) { { new_email: 'new_email@example.com', password: 'invalid' } }

    before { login user }

    context '正常系' do
      it '正しいパスワードと新しいメールアドレスを送信すると確認メール送信メッセージが返る' do
        expect {
          post "/api/v1/email_change_requests", params: new_email_params
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('確認メールを送信しました')
      end
    end

    context '異常系' do
      it '誤ったパスワードを送信するとエラーメッセージが返る' do
        expect {
          post "/api/v1/email_change_requests", params: invalid_params
        }.not_to change { ActionMailer::Base.deliveries.count }
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('パスワードが間違っています')
      end
    end
  end

  describe 'GET /api/v1/email_change_requests/confirm' do
    let!(:user) { create(:user) }
    let!(:email_change_request) { create(:email_change_request, user: user) }
    let!(:invalid_request) { create(:email_change_request, user: user, expires_at: Date.yesterday, token: 'invalid') }
    before { login user }

    context '正常系' do
      it '有効なトークンを指定するとメールアドレスが更新され、確認メッセージが返ること' do
        expect {
          get "/api/v1/email_change_requests/confirm", params: { token: email_change_request.token }
        }.to change(EmailChangeRequest, :count).by(-1)
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('メールアドレスを変更しました')
      end
    end

    context '異常系' do
      it '無効または期限切れのトークンを指定するとエラーメッセージが返ること' do
        expect {
          get "/api/v1/email_change_requests/confirm", params: { token: 'invalid' }
        }.to_not change(EmailChangeRequest, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('リンクが無効または期限切れです')
      end
    end
  end
end
