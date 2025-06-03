class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save 

      token = TokenGenerator.encode(user.id)
      domain = Rails.env.production? ? 'vegeguidebackend.onrender.com' : nil
      cookies[:jwt] = {
        value: token,
        expires: 24.hours.from_now,
        secure: Rails.env.production?,
        httponly: true,
        same_site: :none,
        path: '/',
        domain: domain
      }

      render json: { status: "ユーザーの登録に成功しました", name: user.name }
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private 

  def user_params
    params.permit(:name, :email, :password)
  end
end