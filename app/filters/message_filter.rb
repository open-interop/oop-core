# frozen_string_literal: true

# Filter the messages table using the provided fields
class MessageFilter < BaseFilter
  filterable_attributes integer: %w[id device_id schedule_id],
                        string: %w[uuid],
                        boolean: %w[],
                        datetime: %w[created_at updated_at]

  sortable_attributes %w[
    id device_id schedule_id uuid
    created_at updated_at
  ]

  def base_scope
    Message
      .includes(:account)
      .where(accounts: { id: scope })
  end

  def table_name
    Message.table_name
  end
end
