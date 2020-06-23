# frozen_string_literal: true

# Filter the layers table using the provided fields
class LayerFilter < BaseFilter
  filterable_attributes integer: %w[id],
                        string: %w[name reference],
                        boolean: %w[archived]

  default_sort field: 'name', direction: 'asc'
  sortable_attributes %w[id name reference archived]

  def base_scope
    Layer
      .includes(:account)
      .where(accounts: { id: scope })
  end

  def table_name
    Layer.table_name
  end
end
