class CreateLibraries < ActiveRecord::Migration[5.1]
  def change
    create_table :libraries do |t|
      t.string :name
      t.string :code
      t.string :url
      t.string :version

      t.timestamps null: false
    end
  end
end
