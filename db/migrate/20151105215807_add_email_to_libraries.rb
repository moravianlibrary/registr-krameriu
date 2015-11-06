class AddEmailToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :email, :string
  end
end
