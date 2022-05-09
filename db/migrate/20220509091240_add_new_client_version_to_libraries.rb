class AddNewClientVersionToLibraries < ActiveRecord::Migration[5.1]
  def change
    add_column :libraries, :new_client_version, :string
  end
end
