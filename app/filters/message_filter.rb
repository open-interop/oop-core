# frozen_string_literal: true

# Filter the messages table using the provided fields
class MessageFilter < BaseFilter
  filterable_attributes integer: %w[id device_id schedule_id origin_id transmission_count],
                        string: %w[uuid origin_type ip_address state custom_field_a custom_field_b],
                        boolean: %w[retried],
                        datetime: %w[created_at updated_at retried_at]

  sortable_attributes %w[
    id device_id schedule_id origin_id origin_type
    transmission_count uuid created_at updated_at ip_address state
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
