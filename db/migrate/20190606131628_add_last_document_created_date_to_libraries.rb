class AddLastDocumentCreatedDateToLibraries < ActiveRecord::Migration[5.1]
  def change
    add_column :libraries, :last_document_at, :datetime
  end
end
