class AddMessageIdToTransmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :transmissions, :message_id, :integer
  end
end
