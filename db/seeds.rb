require 'csv'

csv_file_path = Rails.root.join('db', 'vegeguide.csv') 
nutrition_csv_path = Rails.root.join('db', 'vegetable_nutritions.csv')

CSV.foreach(csv_file_path, headers: true, encoding: 'utf-8') do |row|
  vegetable = Vegetable.find_or_initialize_by(name: row['name'])
  vegetable.description = row['description']
  vegetable.origin = row['origin']
  vegetable.storage = row['storage']
  vegetable.image_url = row['image_url'].presence
  vegetable.save!  # ← ここが大事！

  # 保存されたあとでSeasonを作成
  if row['start_month'].present? && row['end_month'].present?
    vegetable.seasons.find_or_create_by!(
      start_month: row['start_month'].to_i,
      end_month: row['end_month'].to_i,
      note: row['note']
    )
  end
end

nutrition_types = [
  { name: 'ビタミンC', unit: 'mg' },
  { name: 'ビタミンE', unit: 'mg' },
  { name: 'βカロテン', unit: 'μg' },
  { name: 'カルシウム', unit: 'mg' },
  { name: 'カリウム', unit: 'mg' },
  { name: '食物繊維', unit: 'g' }
]

# 栄養素タイプ登録（unitも確実に入るように）
nutrition_types.each do |attrs|
  nt = NutritionType.find_or_initialize_by(name: attrs[:name])
  nt.unit = attrs[:unit]
  nt.save!
end

# 栄養データ登録
CSV.foreach(nutrition_csv_path, headers: true, encoding: 'utf-8') do |row|
  vegetable_name = row['vegetable_name'].to_s.strip
  nutrition_name = row['nutrition_name'].to_s.strip

  vegetable = Vegetable.find_by(name: vegetable_name)
  nutrition = NutritionType.find_by(name: nutrition_name)

  if vegetable.nil?
    puts "野菜名が見つかりませんでした: #{vegetable_name}"
  end

  if nutrition.nil?
    puts "栄養素名が見つかりませんでした: #{nutrition_name}"
  end

  if vegetable && nutrition
    VegetableNutrition.find_or_create_by!(
      vegetable: vegetable,
      nutrition_type: nutrition 
    ) do |vn|
      vn.amount = row['amount'].to_f
    end
  else
    puts "野菜名または栄養素名が見つかりませんでした。#{vegetable_name}/ #{nutrition_name}"
  end
end
