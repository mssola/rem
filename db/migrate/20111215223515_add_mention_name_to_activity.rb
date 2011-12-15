class AddMentionNameToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :mention_name, :string
  end
end
