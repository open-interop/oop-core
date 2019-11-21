# frozen_string_literal: true

# Filter the sites table using the provided fields
class SiteFilter < BaseFilter
  filterable_attributes integer: %w[id account_id site_id latitude longitude],
                        string: %w[
                          name full_name description address city
                          state zip_code country region time_zone
                        ],
                        boolean: %w[]

  default_sort field: 'full_name', direction: 'asc'
  sortable_attributes %w[
    id account_id site_id
    name full_name description address city
    state zip_code country region time_zone
  ]

  def base_scope
    Site
      .includes(:account)
      .where(accounts: { id: scope.id })
  end

  def table_name
    Site.table_name
  end
end
