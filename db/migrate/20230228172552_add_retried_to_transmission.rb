class AddRetriedToTransmission < ActiveRecord::Migration[6.1]
  def change
    add_column :transmissions, :retried, :boolean, default: false
  end
end
