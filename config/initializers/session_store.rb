Rails.application.config.session_store :cookie_store,
  key: 'csrf_token',
  same_site: :none,
  secure: Rails.env.production?,
  httponly: true,
  path: '/',
  domain: Rails.env.production? ? 'vegeguidebackend.onrender.com' : nil
Rails.application.config.action_dispatch.cookies_same_site_protection = :none