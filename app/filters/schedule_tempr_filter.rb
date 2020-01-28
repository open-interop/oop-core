# frozen_string_literal: true

# Filter the transmissions table using the provided fields
class ScheduleTemprFilter < BaseFilter
  filterable_attributes integer: %w[id schedule_id tempr_id],
                        string: %w[],
                        boolean: %w[]

  require_one_of %w[schedule_id tempr_id]

  sortable_attributes %w[id schedule_id tempr_id]

  def base_scope
    ScheduleTempr
  end

  def table_name
    ScheduleTempr.table_name
  end
end
