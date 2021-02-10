class AddPackageFieldsToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :devices_limit, :integer, default: 0
    add_column :accounts, :device_groups_limit, :integer, default: 0
    add_column :accounts, :layers_limit, :integer, default: 0
    add_column :accounts, :schedules_limit, :integer, default: 0
    add_column :accounts, :sites_limit, :integer, default: 0
    add_column :accounts, :temprs_limit, :integer, default: 0
    add_column :accounts, :users_limit, :integer, default: 0
    add_column :accounts, :package_id, :bigint
  end
end
