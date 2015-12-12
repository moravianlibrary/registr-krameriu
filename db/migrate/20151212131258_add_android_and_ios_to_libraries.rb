class AddAndroidAndIosToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :android, :integer, default: 0
    add_column :libraries, :ios, :integer, default: 0
  end
end
