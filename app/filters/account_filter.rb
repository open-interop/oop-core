# frozen_string_literal: true

# Filter the accounts table using the provided fields
class AccountFilter < BaseFilter
  filterable_attributes integer: %w[id],
                        string: %w[hostname],
                        boolean: %w[]

  default_sort field: 'hostname', direction: 'asc'
  sortable_attributes %w[id hostname]

  def base_scope
    Account.all
  end

  def table_name
    Account.table_name
  end
end
