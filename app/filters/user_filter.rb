# frozen_string_literal: true

# Filter the users table using the provided fields
class UserFilter < BaseFilter
  filterable_attributes integer: %w[id],
                        string: %w[email time_zone],
                        boolean: %w[]

  sortable_attributes %w[id email time_zone]

  def base_scope
    User
      .includes(:account)
      .where(accounts: { id: scope.id })
  end

  def table_name
    User.table_name
  end
end
