class AddRetriedAtToTransmission < ActiveRecord::Migration[6.1]
  def change
    add_column :transmissions, :retried_at, :datetime
  end
end
