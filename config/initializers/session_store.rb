Rails.application.config.session_store :cookie_store,
  key: "_vegeguide_session",
  same_site: :none,
  secure: Rails.env.production?,
  httponly: true,
  path: "/",
  domain: Rails.env.production? ? "vegeguidebackend.onrender.com" : nil

Rails.application.config.action_dispatch.cookies_same_site_protection = :none

Rails.application.config.middleware.use ActionDispatch::Cookies
Rails.application.config.middleware.use ActionDispatch::Session::CookieStore,
  Rails.application.config.session_options
