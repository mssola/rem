class AddProtectedAndRatingToRoute < ActiveRecord::Migration
  def change
    add_column :routes, :protected, :boolean
    add_column :routes, :rating, :integer
  end
end
