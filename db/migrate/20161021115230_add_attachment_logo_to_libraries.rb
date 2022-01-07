class AddAttachmentLogoToLibraries < ActiveRecord::Migration[5.1]
  def self.up
    change_table :libraries do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :libraries, :logo
  end
end
