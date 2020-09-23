class AddStateToTransmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :transmissions, :state, :string
  end
end
