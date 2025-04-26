class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save 
      token = TokenGenerator.encode(user) if user.save
      
      cookies[:jwt] = {
        value: token,
        expire: 24.hours.from_now,
        secure: Rails.env.production?,
        httponly: true
      }
    render json: { status: "ユーザーの登録に成功しました" }
    else
      render json: { error: "ユーザーの登録に失敗しました" }, status: :unprocessable_entity
    end
  end

  private 

  def user_params
    params.permit(:name, :email, :password)
  end
end