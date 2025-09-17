Rails.application.configure do
  config.good_job.execution_mode = :async
  config.good_job.queues = '*'
  config.good_job.max_threads = 2
  config.good_job.poll_interval = 30
  config.good_job.shutdown_timeout = 25
  config.good_job.dashboard_default_locale = :ja
  config.good_job.enable_cron = true
  config.good_job.cron = {
    import_data_job: {
      cron: '0 22 * * 2',
      class: 'ImportMarketDataJob',
        description: '野菜価格情報APIを叩いて情報の取得'
    },
    export_prices_job: {
      cron: '0 23 * * 2',
      class: 'ExportPricesToCsvJob',
        description: '最新の価格情報をCSV出力'
    },
    purge_blob_job: {
      cron: '0 23 * * *',
      class: 'PurgeUnattachedBlobJob',
        description: '不要な画像データの削除'
    },
  }
end

GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(Rails.application.credentials.dig(:good_job, :username), username) &&
  ActiveSupport::SecurityUtils.secure_compare(Rails.application.credentials.dig(:good_job, :password), password)
end