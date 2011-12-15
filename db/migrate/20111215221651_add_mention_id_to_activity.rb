class AddMentionIdToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :mention_id, :integer
  end
end
