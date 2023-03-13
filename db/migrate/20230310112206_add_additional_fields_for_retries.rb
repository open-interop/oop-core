class AddAdditionalFieldsForRetries < ActiveRecord::Migration[6.1]
  def change
    add_column :transmissions, :request_host, :string
    add_column :transmissions, :request_port, :integer
    add_column :transmissions, :request_path, :string
    add_column :transmissions, :request_protocol, :string
    add_column :transmissions, :request_method, :string
    add_column :transmissions, :request_headers, :text
  end
end
