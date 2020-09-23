class AddStoreBooleanToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :queue_messages, :boolean, default: false
  end
end
