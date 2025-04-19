require 'csv'

csv_file_path = Rails.root.join('db', 'vegeguide.csv') 

CSV.foreach(csv_file_path, headers: true, encoding: 'bom|utf-8') do |row|
    Vegetable.create!(
      name: row['name'],
      description: row['description'],
      origin: row['origin'],
      storage: row['storage'],
      image_url: row['image_url']
    )
end