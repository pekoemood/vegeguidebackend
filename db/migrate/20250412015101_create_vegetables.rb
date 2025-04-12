class CreateVegetables < ActiveRecord::Migration[7.2]
  def change
    create_table :vegetables do |t|
      t.string :name
      t.text :description
      t.string :season
      t.string :origin
      t.string :storage

      t.timestamps
    end

    add_index :vegetables, :name, unique: true
  end
end
