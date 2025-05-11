require 'csv'

price_csv_path = Rails.root.join('db', 'backup', 'prices_backup.csv')

#価格情報の登録
CSV.foreach(price_csv_path, headers: true, encoding: 'utf-8') do |row|
  vegetable_id = row['vegetable_id'].to_i
  date = row['date']

  next if Price.exists?(vegetable_id: vegetable_id, date: date)

  vegetable = Vegetable.find_by(id: vegetable_id)
  unless vegetable
    puts "#{vegetable_id}が見つかりませんでした"
    next
  end
  
  vegetable.prices.create!(
    price: row['price'].to_i,
    market: row['market'],
    date: row['date']
  )
end