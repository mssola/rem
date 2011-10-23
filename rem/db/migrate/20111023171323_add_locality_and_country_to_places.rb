class AddLocalityAndCountryToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :locality, :string
    add_column :places, :country, :string
  end
end
