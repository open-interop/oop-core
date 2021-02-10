# frozen_string_literal: true

# Filter the accounts table using the provided fields
class PackageFilter < BaseFilter
  filterable_attributes integer: %w[id devices_limit device_groups_limit layers_limit
                                      schedules_limit sites_limit temprs_limit users_limit],
                        string: %w[name],
                        boolean: %w[]

  default_sort field: 'name', direction: 'asc'
  sortable_attributes %w[id name devices_limit device_groups_limit layers_limit
                          schedules_limit sites_limit temprs_limit users_limit]

  def base_scope
    Package.all
  end

  def table_name
    Package.table_name
  end
end
