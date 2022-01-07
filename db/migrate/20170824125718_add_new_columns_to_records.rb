class AddNewColumnsToRecords < ActiveRecord::Migration[5.1]
  def change
    remove_column :records, :which
    remove_column :records, :value
    add_column :records, :documents_all, :integer
    add_column :records, :documents_public, :integer
    add_column :records, :pages_all, :integer
    add_column :records, :pages_public, :integer
  end
end
