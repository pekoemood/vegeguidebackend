class Api::V1::AuthenticationController < ApplicationController

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
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
      render json: { name: user.name }
    else
      render json: { status: "メールアドレスかパスワードが間違っています。" }, status: :unprocessable_entity
    end
  end

  def logout
    domain = Rails.env.production? ? 'vegeguidebackend.onrender.com' : nil
    cookies.delete(:jwt, domain: domain, path: '/')
    render json: { message: 'ログアウトしました' }, status: :ok
  end

  def check_login_status
    if @current_user
      render json: { logged_in: true, name: @current_user.name }, status: :ok
    else
      render json: { logged_in: false, name: "" }, status: :unauthorized
    end
  end


  def show_request
    token = cookies[:jwt]
    decode = TokenGenerator.decode(token)['token']
    user = User.find_by(id: decode)
    render json: { name: user.name, email: user.email }
  end
end
