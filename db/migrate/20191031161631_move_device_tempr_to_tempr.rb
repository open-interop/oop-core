class MoveDeviceTemprToTempr < ActiveRecord::Migration[6.0]
  def up
    Tempr.all.each do |tempr|
      device_tempr = tempr.device_temprs.first

      tempr.endpoint_type = device_tempr.endpoint_type
      tempr.queue_response = device_tempr.queue_response
      tempr.template = device_tempr.template
      tempr.save!
    end
  end
end
