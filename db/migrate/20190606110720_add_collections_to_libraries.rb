class AddCollectionsToLibraries < ActiveRecord::Migration[5.1]
  def change
    add_column :libraries, :collections, :integer
  end
end
