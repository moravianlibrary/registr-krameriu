class AddLastStateSwitchToLibraries < ActiveRecord::Migration[5.1]
  def change
    add_column :libraries, :last_state_switch, :datetime
  end
end
