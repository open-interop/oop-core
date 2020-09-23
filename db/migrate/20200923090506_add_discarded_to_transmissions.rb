class AddDiscardedToTransmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :transmissions, :discarded, :boolean, default: false
  end
end
