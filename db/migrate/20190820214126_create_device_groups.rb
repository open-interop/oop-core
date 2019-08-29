class CreateDeviceGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :device_groups do |t|
      t.integer :account_id

      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
