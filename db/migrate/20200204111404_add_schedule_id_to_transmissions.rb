class AddScheduleIdToTransmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :transmissions, :schedule_id, :integer
    remove_column :transmissions, :device_tempr_id, :integer
  end
end
