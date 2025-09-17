class CreateSeasons < ActiveRecord::Migration[7.2]
  def change
    create_table :seasons do |t|
      t.references :vegetable, null: false, foreign_key: true
      t.integer :start_month
      t.integer :end_month

      t.timestamps
    end
  end
end
