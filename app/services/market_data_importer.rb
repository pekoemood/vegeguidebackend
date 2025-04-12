class MarketDataImporter
  def initialize(api_data)
    @api_data = api_data
  end

  def import 
    date = @api_data["Date"]
    city = @api_data["CityName"]

    @api_data.each do |key, value|
      next if %w(Date CityName CityCode 野菜総量 その他の野菜 輸入野菜計 その他の輸入野菜).include?(key)
      vegetable_name = key
      price = @api_data[vegetable_name]['総量']['AveragePrice']&.to_i
      price_variation = @api_data[vegetable_name]['総量']['PriceVersusPreviousDay']&.to_f
      next if price.nil? || price_variation.nil?

      begin
      
        new_vegetable = Vegetable.find_or_create_by!(name: vegetable_name)

        new_vegetable.prices.create!(
          price: price, 
          market: city, 
          date: date, 
          price_variation: price_variation
          )
      rescue => e
        Rails.logger.error("インポートに失敗しました#{vegetable_name}#{price}: #{e.message}")
      end
    end
  end
end