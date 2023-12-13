class AddSaveConsoleToTemprs < ActiveRecord::Migration[6.1]
  def change
    add_column :temprs, :save_console, :boolean, default: false
  end
end
