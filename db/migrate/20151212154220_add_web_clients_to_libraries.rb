class AddWebClientsToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :k4_client, :boolean, deault: true
    add_column :libraries, :k5_client_url, :string
    add_column :libraries, :alt_client_url, :string
    add_column :libraries, :alt_client_universal, :boolean, deault: false
  end
end
