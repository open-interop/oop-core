# frozen_string_literal: true

class DevicePresenter < BasePresenter
  attributes :id, :name, :device_group_id, :site_id,
             :latitude, :longitude, :time_zone, :created_at,
             :updated_at, :active, :queue_messages

  def self.record_for_microservices(device)
    {
      id: device.id,
      authentication: device.authentication,
      temprUrl: device.tempr_url
    }
  end

  def self.collection_for_microservices(devices)
    devices.map do |device|
      record_for_microservices(device)
    end
  end
end
