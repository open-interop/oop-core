# frozen_string_literal: true

class DeviceTemprFilter < BaseFilter
  filterable_attributes integer: %w[device_id tempr_id],
                        string: %w[endpoint_type],
                        boolean: %w[queue_response]

  def base_scope
    DeviceTempr.includes(:device)
               .where(
                 devices: {
                   device_group_id: scope.id
                 }
               )
  end
end
