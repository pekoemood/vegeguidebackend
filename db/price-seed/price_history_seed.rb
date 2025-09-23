require 'csv'

csv_file_path = Rails.root.join('db', 'price-seed', 'price_history.csv')

    EXCLUDED_KEYS = %w[Date CityName CityCode 野菜総量 その他の野菜 輸入野菜計 その他の輸入野菜 その他の菜類 アスパラガス（うち輸入） ブロッコリー（うち輸入）
    かぼちゃ（うち輸入） さやえんどう（うち輸入） たまねぎ（うち輸入） にんにく（うち輸入） しょうが（うち輸入） 生しいたけ（うち輸入）
    ]

CSV.foreach(csv_file_path, headers: true, encoding: 'utf-8') do |row|
  next if EXCLUDED_KEYS.include?(row['品目名']) || row['産地名'].present?

  vegetable = Vegetable.find_by(name: row['品目名'].strip)

  unless vegetable
    puts "品目名に一致する野菜が見つかりませんでした: #{row['品目名']}"
    next
  end

  date = Date.new(row['年'].to_i, row['月'].to_i, row['日'].to_i)
  market = '主要卸売市場計'

  existing_price = Price.find_by(vegetable_id: vegetable.id, date: date, market: market)
  next if existing_price

  Price.create!(
    vegetable_id: vegetable.id,
    price: row['価格'].to_i,
    date: date,
    market: market
  )
end

puts '価格データのインポートが完了しました'
