class AddAttachmentLogoToLibraries < ActiveRecord::Migration
  def self.up
    change_table :libraries do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :libraries, :logo
  end
end
