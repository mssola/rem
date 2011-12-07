class AddIndexToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :index, :integer
  end
end
