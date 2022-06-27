class RenameOmnibus < ActiveRecord::Migration[5.1]
  def change
    rename_column :libraries, :model_oldprintomnibusvolume_all, :model_convolute_all
    rename_column :libraries, :model_oldprintomnibusvolume_public, :model_convolute_public
  end
end
