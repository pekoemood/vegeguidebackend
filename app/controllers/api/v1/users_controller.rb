class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save 

      token = TokenGenerator.encode(user.id)
      cookies[:jwt] = {
        value: token,
        expires: 24.hours.from_now,
        secure: Rails.env.production?,
        httponly: true,
        same_site: :none
      }

      render json: { status: "ユーザーの登録に成功しました" }
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private 

  def user_params
    params.permit(:name, :email, :password)
  end
end