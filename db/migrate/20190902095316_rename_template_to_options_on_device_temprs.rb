class RenameTemplateToOptionsOnDeviceTemprs < ActiveRecord::Migration[6.0]
  def change
    rename_column :device_temprs, :template, :options
  end
end
