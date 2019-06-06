class AddModelCountsToLibraries < ActiveRecord::Migration[5.1]
  def change
    add_column :libraries, :model_monograph_all, :integer
    add_column :libraries, :model_monograph_public, :integer

    add_column :libraries, :model_periodical_all, :integer
    add_column :libraries, :model_periodical_public, :integer

    add_column :libraries, :model_soundrecording_all, :integer
    add_column :libraries, :model_soundrecording_public, :integer

    add_column :libraries, :model_map_all, :integer
    add_column :libraries, :model_map_public, :integer
    
    add_column :libraries, :model_graphic_all, :integer
    add_column :libraries, :model_graphic_public, :integer

    add_column :libraries, :model_sheetmusic_all, :integer
    add_column :libraries, :model_sheetmusic_public, :integer
    
    add_column :libraries, :model_archive_all, :integer
    add_column :libraries, :model_archive_public, :integer

    add_column :libraries, :model_manuscript_all, :integer
    add_column :libraries, :model_manuscript_public, :integer
    
    add_column :libraries, :model_article_all, :integer
    add_column :libraries, :model_article_public, :integer

  end
end
