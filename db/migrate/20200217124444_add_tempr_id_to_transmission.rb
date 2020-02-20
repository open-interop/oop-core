class AddTemprIdToTransmission < ActiveRecord::Migration[6.0]
  def change
    add_column :transmissions, :tempr_id, :integer
  end
end
