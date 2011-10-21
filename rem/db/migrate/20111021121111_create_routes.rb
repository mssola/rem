class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.integer :user_id
      t.string :name
      t.text :desc

      t.timestamps
    end
  end
end
