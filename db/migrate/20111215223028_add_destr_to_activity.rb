class AddDestrToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :destr, :boolean, :default => false
  end
end
