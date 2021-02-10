class CreatePackage < ActiveRecord::Migration[6.0]
  def change
    create_table :packages do |t|
      t.integer :devices_limit, default: 0
      t.integer :device_groups_limit, default: 0
      t.integer :layers_limit, default: 0
      t.integer :schedules_limit, default: 0
      t.integer :sites_limit, default: 0
      t.integer :temprs_limit, default: 0
      t.integer :users_limit, default: 0

      t.string :name

      t.timestamps
    end
  end
end
