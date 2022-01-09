class AddNewModelsToLibraries < ActiveRecord::Migration[5.1]
  def change
    add_column :libraries, :model_periodicalitem_all, :integer
    add_column :libraries, :model_periodicalitem_public, :integer

    add_column :libraries, :model_supplement_all, :integer
    add_column :libraries, :model_supplement_public, :integer

    add_column :libraries, :model_periodicalvolume_all, :integer
    add_column :libraries, :model_periodicalvolume_public, :integer

    add_column :libraries, :model_monographunit_all, :integer
    add_column :libraries, :model_monographunit_public, :integer

    add_column :libraries, :model_track_all, :integer
    add_column :libraries, :model_track_public, :integer

    add_column :libraries, :model_soundunit_all, :integer
    add_column :libraries, :model_soundunit_public, :integer

    add_column :libraries, :model_internalpart_all, :integer
    add_column :libraries, :model_internalpart_public, :integer

    add_column :libraries, :model_oldprintomnibusvolume_all, :integer
    add_column :libraries, :model_oldprintomnibusvolume_public, :integer

    add_column :libraries, :model_picture_all, :integer
    add_column :libraries, :model_picture_public, :integer
  end
end
