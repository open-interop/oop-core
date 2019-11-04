class AddDeviceTemprFieldsToTempr < ActiveRecord::Migration[6.0]
  def change
    add_column :temprs, :endpoint_type, :string
    add_column :temprs, :queue_response, :boolean, default: false
    add_column :temprs, :queue_request, :boolean, default: false
    add_column :temprs, :template, :text
  end
end
