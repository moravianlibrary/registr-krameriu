class AddLicensesToLibraries < ActiveRecord::Migration[5.1]
  def change
    add_column :libraries, :licenses, :string
  end
end
