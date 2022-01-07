class AddDocumentCountToLibraries < ActiveRecord::Migration[5.1]
  def change
    add_column :libraries, :documents_all, :integer
    add_column :libraries, :documents_public, :integer
  end
end
