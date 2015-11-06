class AddDocumentCountToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :documents_all, :integer
    add_column :libraries, :documents_public, :integer
  end
end
