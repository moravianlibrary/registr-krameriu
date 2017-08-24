class RenameTypeInRecordsToWhich < ActiveRecord::Migration
  def change
    rename_column :records, :type, :which
  end
end
