class AddRecommendedToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :recommended, :integer
    add_column :libraries, :recommended_public, :integer
  end
end
