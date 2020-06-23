# frozen_string_literal: true

# Filter the tempr layer association table using the provided fields
class TemprLayerFilter < BaseFilter
  filterable_attributes integer: %w[id layer_id tempr_id],
                        string: %w[],
                        boolean: %w[]

  require_one_of %w[layer_id tempr_id]

  sortable_attributes %w[id layer_id tempr_id]

  def base_scope
    TemprLayer
  end

  def table_name
    TemprLayer.table_name
  end
end
