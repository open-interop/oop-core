class AddAccountIdToTransmissions < ActiveRecord::Migration[6.0]
  def up
    add_column :transmissions, :account_id, :integer

    Transmission.reset_column_information

    Device.includes(:account).all.each do |device|
      device.transmissions.update_all(account_id: device.account_id)
    end

    Schedule.includes(:account).all.each do |schedule|
      schedule.transmissions.update_all(account_id: schedule.account_id)
    end
  end

  def down
    remove_column :transmissions, :account_id, :integer
  end
end
