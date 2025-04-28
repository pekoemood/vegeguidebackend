class ApplicationController < ActionController::API
  include ActionController::Cookies
  before_action :set_current_user

  def set_current_user
    token = cookies[:jwt]
    if token
      decode_id = TokenGenerator.decode(token)['token']
      @current_user = User.find_by(id: decode_id)
    end
  end

  def authenticate_user!
    unless @current_user
      render json: { error: 'ログインしてください'}, status: :unauthorized
    end
  end
end
