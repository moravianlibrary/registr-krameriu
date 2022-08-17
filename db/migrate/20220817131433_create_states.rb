class CreateStates < ActiveRecord::Migration[5.1]
  def change
    create_table :states do |t|
      t.references :library, foreign_key: true
      t.integer :value
      t.datetime :at
    end
  end
end
