class AddFieldstoRecords < ActiveRecord::Migration
  def change
    add_column :records, :inc_documents_all, :integer, default: 0
    add_column :records, :inc_documents_public, :integer, default: 0
    add_column :records, :inc_pages_all, :integer, default: 0
    add_column :records, :inc_pages_public, :integer, default: 0
  end
end
