class DropTempImagesTable < ActiveRecord::Migration[7.2]
  def up
    drop_table :temp_images
  end

  def down
    create_table :temp_images do |t|
      t.timestamps
    end
  end
end
