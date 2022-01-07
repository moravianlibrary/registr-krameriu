class RenameTypeInRecordsToWhich < ActiveRecord::Migration[5.1]
  def change
    rename_column :records, :type, :which
  end
end
