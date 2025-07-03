require 'rails_helper'

RSpec.describe "Api::V1::Authentications", type: :request do
  describe "POST /api/v1/login" do
    let!(:user) { create(:user, password: "password") }

    context "正しいメールアドレスとパスワードを送信した場合" do
      it "ログインに成功し、JWTクッキーとユーザー情報を返す" do
        post api_v1_login_path, params: { email: user.email, password: "password" }

        expect(response).to have_http_status(:ok)
        expect(response.cookies["jwt"]).to be_present

        json = JSON.parse(response.body)
        expect(json["name"]).to eq(user.name)
        expect(json["email"]).to eq(user.email)
      end
    end

    context '誤ったパスワードを送信した場合' do
      it "ログインに失敗し、エラーメッセージを返す" do
        post api_v1_login_path, params: { email: user.email, password: "wrongpassword" }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['status']).to eq("メールアドレスかパスワードが間違っています。")
      end
    end
  end

  describe "POST api/v1/logout" do
    let!(:user) { create(:user) }

    it "ログアウトに成功し、ログアウトメッセージを返す" do
      login user
      post api_v1_logout_path

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['message']).to eq("ログアウトしました")
      expect(response.cookies['jwt']).to be_nil
    end
  end

  describe "GET api/v1/check_login_status" do
    let!(:user) { create(:user) }

    it 'ログイン中はユーザー情報を返す' do
      login user
      get api_v1_check_login_status_path
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['name']).to eq(user.name)
      expect(json['logged_in']).to be_truthy
    end

    it 'ログインしていない場合はfalseを返す' do
      get api_v1_check_login_status_path
      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body)
      expect(json['logged_in']).to be_falsey
    end
  end

  describe
end
