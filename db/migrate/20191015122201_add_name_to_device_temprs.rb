class AddNameToDeviceTemprs < ActiveRecord::Migration[6.0]
  def change
    add_column :device_temprs, :name, :string
  end
end
