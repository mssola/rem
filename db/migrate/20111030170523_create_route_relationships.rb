class CreateRouteRelationships < ActiveRecord::Migration
  def change
    create_table :route_relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
  end
end
