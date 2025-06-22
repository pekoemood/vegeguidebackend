class CreateTempImages < ActiveRecord::Migration[7.2]
  def change
    create_table :temp_images do |t|
      t.timestamps
    end
  end
end
