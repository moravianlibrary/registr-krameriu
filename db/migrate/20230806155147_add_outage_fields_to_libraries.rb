class AddOutageFieldsToLibraries < ActiveRecord::Migration[5.2]
  def change
    add_column :libraries, :outage_warning_counter, :integer, default: 0
    add_column :libraries, :outage_warning_emails, :string, default: ""
  end
end
