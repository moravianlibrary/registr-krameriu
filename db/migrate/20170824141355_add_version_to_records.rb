class AddVersionToRecords < ActiveRecord::Migration
  def change
    add_column :records, :version, :string
  end
end
