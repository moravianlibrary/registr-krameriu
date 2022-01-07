class AddWebClientsToLibraries < ActiveRecord::Migration[5.1]
  def change
    add_column :libraries, :k4_client, :boolean, default: true
    add_column :libraries, :k5_client_url, :string
    add_column :libraries, :alt_client_url, :string
    add_column :libraries, :alt_client_universal, :boolean, default: false
  end
end
