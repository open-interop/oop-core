# frozen_string_literal: true

# Filter the blacklist_entries table using the provided fields
class BlacklistEntryFilter < BaseFilter
  filterable_attributes integer: %w[id],
                        boolean: %w[archived]

  default_sort field: 'id', direction: 'asc'
  sortable_attributes %w[id archived]

  def base_scope
    BlacklistEntry
      .includes(:account)
      .where(accounts: { id: scope })
  end

  def table_name
    BlacklistEntry.table_name
  end
end

