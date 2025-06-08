class Api::V1::PasswordsController < ApplicationController
  before_action :authenticate_user!

  def update
    old_password = password_params[:old_password]
    new_password = password_params[:new_password]

    unless @current_user.authenticate(old_password)
      return render json: { status: 'failed', message: '現在のパスワードが正しくありません' }, status: :unprocessable_entity
    end

    if @current_user.update(password: new_password)
      render json: { status: 'success', message: 'パスワードの更新に成功しました'}, status: :ok
    else
      render json: { status: 'failed', errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def password_params
      params.permit(:old_password, :new_password)
    end
end
