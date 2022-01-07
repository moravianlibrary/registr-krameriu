class AddMoreInfoToLibraries < ActiveRecord::Migration[5.1]
  def change
    add_column :libraries, :intro, :string
    add_column :libraries, :right_msg, :string
    add_column :libraries, :pdf_max, :integer
  end
end
