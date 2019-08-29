class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.integer :account_id
      t.integer :device_group_id
      t.integer :site_id

      t.string :name

      t.text :authentication_headers
      t.text :authentication_query
      t.string :authentication_path

      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.string :time_zone

      t.timestamps
    end
  end
end
