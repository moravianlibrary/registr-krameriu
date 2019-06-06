class AddNewFieldsToLibraries < ActiveRecord::Migration[5.1]
  def change
    add_column :libraries, :new_client_url, :string
    add_column :libraries, :sigla, :string
    add_column :libraries, :oai_provider, :string
    add_column :libraries, :alive, :boolean, default: false
  end
end
