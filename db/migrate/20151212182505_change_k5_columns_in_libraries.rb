class ChangeK5ColumnsInLibraries < ActiveRecord::Migration[5.1]
  def change
  	remove_column :libraries, :k5_client_url
  	add_column :libraries, :k5_client, :boolean, default: false
  end
end
