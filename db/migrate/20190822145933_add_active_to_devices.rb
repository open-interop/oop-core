class AddActiveToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :active, :boolean, default: true
  end
end
