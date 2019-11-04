# frozen_string_literal: true

# Filter the devices table using the provided fields
class DeviceFilter < BaseFilter
  filterable_attributes integer: %w[id device_group_id site_id latitude longitude],
                        string: %w[name time_zone],
                        boolean: %w[active]

  def base_scope
    Device
      .includes(:account)
      .where(accounts: { id: scope.id })
      .order("#{table_name}.name asc")
  end

  def table_name
    Device.table_name
  end
end
