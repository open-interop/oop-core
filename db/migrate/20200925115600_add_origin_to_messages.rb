class AddOriginToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :origin_id, :integer
    add_column :messages, :origin_type, :string
    add_column :messages, :transmission_count, :integer, default: 0
  end
end
