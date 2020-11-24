class AddIpAddressToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :ip_address, :string
  end
end
