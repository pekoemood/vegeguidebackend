%w[ vegetable_seed nutrition_seed price_seed ].each do |filename|
  load Rails.root.join('db', 'seeds', "#{filename}.rb")
end

