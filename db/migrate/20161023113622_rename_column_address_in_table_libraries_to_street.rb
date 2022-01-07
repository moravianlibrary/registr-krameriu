class RenameColumnAddressInTableLibrariesToStreet < ActiveRecord::Migration[5.1]
  def change
    rename_column :libraries, :address, :street
  end
end
