# frozen_string_literal: true

# Filter the schedules table using the provided fields
class ScheduleFilter < BaseFilter
  filterable_attributes integer: %w[id],
                        string: %w[name],
                        boolean: %w[active]

  default_sort field: 'name', direction: 'asc'
  sortable_attributes %w[id name active]

  def base_scope
    Schedule
      .includes(:account)
      .where(accounts: { id: scope })
  end

  def table_name
    Schedule.table_name
  end
end
