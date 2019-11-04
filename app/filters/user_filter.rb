# frozen_string_literal: true

# Filter the users table using the provided fields
class UserFilter < BaseFilter
  filterable_attributes integer: %w[id],
                        string: %w[email time_zone],
                        boolean: %w[]

  def base_scope
    User
      .includes(:account)
      .where(accounts: { id: scope.id })
      .order("#{table_name}.created_at desc")
  end

  def table_name
    User.table_name
  end
end
