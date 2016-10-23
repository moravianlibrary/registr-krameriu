class AddColumnsToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :web, :string
    add_column :libraries, :name_en, :string
    add_column :libraries, :city, :string
    add_column :libraries, :address, :string
    add_column :libraries, :zip, :string
    add_column :libraries, :longitude, :float
    add_column :libraries, :latitude, :float
  end
end
