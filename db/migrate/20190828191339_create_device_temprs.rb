class CreateDeviceTemprs < ActiveRecord::Migration[6.0]
  def change
    create_table :device_temprs do |t|
      t.integer :device_id
      t.integer :tempr_id

      t.string :endpoint_type

      t.boolean :queue_response

      t.text :template

      t.timestamps
    end
  end
end
