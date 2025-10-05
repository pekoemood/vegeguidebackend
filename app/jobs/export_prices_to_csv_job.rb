require "csv"

class ExportPricesToCsvJob < ApplicationJob
  queue_as :default

  def perform
    prices = Price.all

    CSV.open("db/backup/prices_backup.csv", "w", write_headers: true, headers: Price.attribute_names) do |csv|
      prices.find_each do |price|
        csv << price.attributes.values
      end
    end
  end
end
