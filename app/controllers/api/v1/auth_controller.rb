require "googleauth/id_tokens"
require "httparty"

class Api::V1::AuthController < ApplicationController
  skip_before_action :verify_authenticity_token
  def google_login
    auth_code = params[:code]
    return render json: { error: "認証コードが見つかりません" }, status: :bad_request if auth_code.blank?

    response = GoogleAuthService.new(auth_code).authenticate!
    if response[:success]
      user = response[:success]
      token = TokenGenerator.encode(user.id)
      cookies[:jwt] = jwt_cookie_options(token)

      render json: { name: user.name, email: user.email, google_account: user.google_uid }, status: :ok
    else
      render json: { error: response[:error] }, status: response[:status] || :unprocessable_entity
    end
  end
end
