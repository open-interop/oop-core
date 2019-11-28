class AddInterfaceFieldsToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :interface_scheme, :string
    add_column :accounts, :interface_port, :integer
    add_column :accounts, :interface_path, :string
  end
end
