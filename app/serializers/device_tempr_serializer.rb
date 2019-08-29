class DeviceTemprSerializer < ActiveModel::Serializer
  attributes :id, :device_id, :tempr_id, :endpoint_type, :queue_response, :template, :created_at, :updated_at
end
