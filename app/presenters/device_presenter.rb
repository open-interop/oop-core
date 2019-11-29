# frozen_string_literal: true

class DevicePresenter < BasePresenter
  attributes :id, :name, :device_group_id, :site_id,
             :latitude, :longitude, :time_zone, :created_at,
             :updated_at, :active
end
