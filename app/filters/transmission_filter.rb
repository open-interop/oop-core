# frozen_string_literal: true

# Filter the transmissions table using the provided fields
class TransmissionFilter < BaseFilter
  filterable_attributes integer: %w[id status tempr_id device_id schedule_id message_id],
                        string: %w[message_uuid transmission_uuid state custom_field_a custom_field_b],
                        boolean: %w[success discarded],
                        datetime: %w[transmitted_at created_at updated_at]

  sortable_attributes %w[
    id device_id message_id tempr_id schedule_id status message_uuid
    transmission_uuid success discarded state transmitted_at
    created_at updated_at 
  ]

  def base_scope
    Transmission
      .includes(:account)
      .where(accounts: { id: scope })
  end

  def table_name
    Transmission.table_name
  end
end
