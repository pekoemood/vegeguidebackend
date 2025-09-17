class AddImageUrlToVegetable < ActiveRecord::Migration[7.2]
  def change
    add_column :vegetables, :image_url, :string
  end
end
