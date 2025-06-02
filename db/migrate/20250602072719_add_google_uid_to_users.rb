class AddGoogleUidToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :google_uid, :string
    add_index :users, :google_uid
  end
end
