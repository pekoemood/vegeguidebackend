class Api::V1::AuthenticationController < ApplicationController

  def login
    user = User.authenticate_by(email: params[:email], password: params[:password])
    if user
      token = TokenGenerator.encode(user.id)
      cookies[:jwt] = jwt_cookie_options(token)
      render json: { name: user.name, email: user.email }
    else
      render json: { status: "メールアドレスかパスワードが間違っています。" }, status: :unprocessable_entity
    end
  end

  def logout
    domain = Rails.env.production? ? 'vegeguidebackend.onrender.com' : nil
    cookies.delete(:jwt, domain: domain, path: '/',secure: Rails.env.production?, httponly: true, same_site: :none)
    Rails.logger.info "JWT cookie after delete: #{cookies[:jwt].inspect}"
    render json: { message: 'ログアウトしました' }, status: :ok
  end

  def check_login_status
    if @current_user
      render json: { logged_in: true, name: @current_user.name, email: @current_user.email, google_account: !!@current_user.google_uid }, status: :ok
    else
      render json: { logged_in: false, name: "" }, status: :unauthorized
    end
  end
end
