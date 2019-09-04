class CreateTransmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :transmissions do |t|
      t.integer :device_id
      t.integer :device_tempr_id

      t.string :message_uuid
      t.string :transmission_uuid

      t.boolean :success
      t.integer :status
      t.datetime :transmitted_at

      t.text :body

      t.timestamps
    end
  end
end
