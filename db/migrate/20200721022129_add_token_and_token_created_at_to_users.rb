class AddTokenAndTokenCreatedAtToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :token, :string
    add_column :users, :token_created_at, :timestamp
  end

  def down
    remove_column :users, :token
    remove_column :users, :token_created_at
  end
end
