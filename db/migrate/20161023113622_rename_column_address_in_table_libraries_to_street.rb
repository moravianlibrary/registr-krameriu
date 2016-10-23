class RenameColumnAddressInTableLibrariesToStreet < ActiveRecord::Migration
  def change
    rename_column :libraries, :address, :street
  end
end
