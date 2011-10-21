class AddNroutesToPlace < ActiveRecord::Migration
  def change
    add_column :places, :nroutes, :integer
  end
end
