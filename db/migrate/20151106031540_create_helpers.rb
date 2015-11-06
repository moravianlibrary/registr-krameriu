class CreateHelpers < ActiveRecord::Migration
  def change
    create_table :helpers do |t|
      t.timestamp :last_update

      t.timestamps null: false
    end
  end
end
