class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.integer :route_id
      t.string :name
      t.text :desc
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
