module AuthHelpers
  def login(user)
    post api_v1_login_path, params: { email: user.email, password: user.password }
    token = response.cookies["jwt"]
    cookies[:jwt] = token if token.present?
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end