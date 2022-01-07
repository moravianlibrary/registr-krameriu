class AddRecommendedToLibraries < ActiveRecord::Migration[5.1]
  def change
    add_column :libraries, :recommended, :integer
    add_column :libraries, :recommended_public, :integer
  end
end
