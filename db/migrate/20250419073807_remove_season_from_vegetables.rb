class RemoveSeasonFromVegetables < ActiveRecord::Migration[7.2]
  def change
    remove_column :vegetables, :season, :string
  end
end
