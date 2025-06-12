class Droptodos < ActiveRecord::Migration[7.2]
  def change
    drop_table :todos, if_exists: true
  end
end
