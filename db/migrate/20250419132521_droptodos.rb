class Droptodos < ActiveRecord::Migration[7.2]
  def change
    drop_table :todos
  end
end
