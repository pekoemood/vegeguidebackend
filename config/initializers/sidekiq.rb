Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end

# 例：config/initializers/sidekiq.rb
Sidekiq::Scheduler.dynamic = true

schedule_file = "config/sidekiq_scheduler.yml"

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Scheduler.load_schedule!
end
