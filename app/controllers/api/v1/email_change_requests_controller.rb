class Api::V1::EmailChangeRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    unless @current_user.authenticate(params[:password])
      return render json: { message: "パスワードが間違っています" }, status: :unprocessable_entity
    end

    new_email = params[:new_email]

    token = SecureRandom.urlsafe_base64(20)
    expires_at = 15.minutes.from_now

    EmailChangeRequest.create!(
      user: @current_user,
      new_email: new_email,
      token: token,
      expires_at: expires_at
    )

    UserMailer.with(user: @current_user, new_email: new_email, token: token).email_change_confirm.deliver_now

    render json: { message: "確認メールを送信しました" }, status: :ok
  end

  def confirm
    request = EmailChangeRequest.find_by(token: params[:token])

    if request.nil? || request.expired?
      return render json: { error: "リンクが無効または期限切れです" }, status: :unprocessable_entity
    end

    user = request.user
    user.update!(email: request.new_email)

    request.destroy

    render json: { message: "メールアドレスを変更しました", email: user.email }, status: :ok
  end
end
