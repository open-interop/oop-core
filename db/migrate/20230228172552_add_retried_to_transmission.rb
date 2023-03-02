class AddRetriedToTransmission < ActiveRecord::Migration[6.1]
  def change
    add_column :transmissions, :retried, :boolean
  end
end
