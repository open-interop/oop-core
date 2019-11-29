# frozen_string_literal: true

# Filter the transmissions table using the provided fields
class DeviceGroupFilter < BaseFilter
  filterable_attributes integer: %w[id],
                        string: %w[name],
                        boolean: %w[]

  default_sort field: 'name', direction: 'asc'
  sortable_attributes %w[id name]

  def base_scope
    DeviceGroup
      .includes(:account)
      .where(accounts: { id: scope })
  end

  def table_name
    DeviceGroup.table_name
  end
end
