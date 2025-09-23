require 'rails_helper'

RSpec.describe "Api::V1::Passwords", type: :request do
  describe "PATCH /api/v1/password" do
    let(:user) { create(:user) }
    let(:params) do { old_password: 'password', new_password: 'newpassword' } end
    let(:invalid_params) do { old_password: 'mispass', new_password: 'new' } end
    let(:invalid_new_pass) do { old_password: 'password', new_password: 'new' } end

    context '正常系' do
      before do
        login user
      end
      it '正しい情報ならパスワードの変更ができる' do
        patch "/api/v1/password", params: params
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('success')
        expect(json['message']).to eq('パスワードの更新に成功しました')
        expect(user.reload.authenticate('newpassword')).to be_truthy
        expect(user.authenticate('password')).to be_falsey
      end
    end

    context '異常系' do
      before do
        login user
      end
      it '現在のパスワードが間違っている場合はエラーを返す' do
        patch "/api/v1/password", params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('failed')
        expect(json['message']).to eq('現在のパスワードが正しくありません')
      end

      it '新しいパスワードが８文字以下ならエラーを返す' do
        patch "/api/v1/password", params: invalid_new_pass
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('failed')
        expect(json['errors']['password']).to include('8文字以上で入力してください')
      end
    end
  end
end
