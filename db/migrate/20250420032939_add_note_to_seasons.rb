class AddNoteToSeasons < ActiveRecord::Migration[7.2]
  def change
    add_column :seasons, :note, :string
  end
end
