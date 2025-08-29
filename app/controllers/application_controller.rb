class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Rails.application.routes.url_helpers
  before_action :set_current_user

  def set_current_user
    token = cookies[:jwt]
    if token
      begin
        decode_id = TokenGenerator.decode(token)['token']
        @current_user = User.find_by(id: decode_id)
      rescue JWT::DecodeError
        @current_user = nil
      end
    else 
      @current_user = nil
    end
  end

  def authenticate_user!
    if @current_user.nil?
      render json: { status: 'ログインしてください' }, status: :unauthorized
      return
    end
  end

  protected

  def jwt_cookie_options(token)
    {
      value: token,
      expires: 24.hours.from_now,
      secure: Rails.env.production?,
      httponly: true,
      same_site: :none,
      path: '/',
      domain: Rails.env.production? ? 'vegeguidebackend.onrender.com' : nil
    }
  end
end
