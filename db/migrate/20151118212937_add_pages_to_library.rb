class AddPagesToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :pages_all, :integer
    add_column :libraries, :pages_public, :integer
  end
end
