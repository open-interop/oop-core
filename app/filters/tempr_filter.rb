# frozen_string_literal: true

# Filter the temprs table using the provided fields
class TemprFilter < BaseFilter
  filterable_attributes integer: %w[id device_group_id],
                        string: %w[name description],
                        boolean: %w[]

  default_sort field: 'name', direction: 'asc'
  sortable_attributes %w[id device_group_id name description]

  def base_scope
    Tempr
      .includes(:account)
      .where(accounts: { id: scope })
  end

  def table_name
    Tempr.table_name
  end
end
