# frozen_string_literal: true

# Filter the audits table using the provided fields
class AuditableFilter < BaseFilter
  filterable_attributes integer: %w[id auditable_id user_id version],
                        string: %w[
                          auditable_type user_type action
                          remote_address request_uuid
                        ],
                        boolean: %w[archived],
                        datetime: %w[created_at]

  default_sort field: 'id', direction: 'asc'
  sortable_attributes %w[id created_at version]

  def base_scope
    Audited::Audit
      .where(associated_type: 'Account', associated_id: scope)
  end

  def table_name
    Audited::Audit.table_name
  end
end
