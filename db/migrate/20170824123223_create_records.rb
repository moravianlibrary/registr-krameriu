class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.references :library, index: true, foreign_key: true
      t.date :date
      t.string :type
      t.integer :value

      t.timestamps null: false
    end
  end
end
