# frozen_string_literal: true

# Filter the transmissions table using the provided fields
class DeviceTemprFilter < BaseFilter
  filterable_attributes integer: %w[id device_id tempr_id],
                        string: %w[],
                        boolean: %w[]

  require_one_of %w[device_id tempr_id]

  sortable_attributes %w[id device_id tempr_id]

  def base_scope
    DeviceTempr
  end

  def table_name
    DeviceTempr.table_name
  end
end
