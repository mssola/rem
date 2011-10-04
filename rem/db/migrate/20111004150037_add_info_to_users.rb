class AddInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :full_name, :string
    add_column :users, :twitter_name, :string
    add_column :users, :url, :string
    add_column :users, :bio, :text
  end
end
