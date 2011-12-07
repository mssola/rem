class RemoveNroutesFromPlaces < ActiveRecord::Migration
  def up
    remove_column :places, :nroutes
  end

  def down
    add_column :places, :nroutes, :integer
  end
end
