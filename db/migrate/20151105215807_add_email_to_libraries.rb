class AddEmailToLibraries < ActiveRecord::Migration[5.1]
  def change
    add_column :libraries, :email, :string
  end
end
