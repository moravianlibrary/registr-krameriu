class AddAndroidAndIosToLibraries < ActiveRecord::Migration[5.1]
  def change
    add_column :libraries, :android, :integer, default: 0
    add_column :libraries, :ios, :integer, default: 0
  end
end
