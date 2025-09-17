class ImportMarketDataJob < ApplicationJob
  queue_as :default

  def perform
    response = MarketDataFetcher.new.fetch
    if response.success?
      MarketDataImporter.new(response).import
    else
      Rails.logger.error("データ取得失敗: #{response.error_message}")
    end
  end
end
