class CreateTemprs < ActiveRecord::Migration[6.0]
  def change
    create_table :temprs do |t|
      t.integer :device_group_id

      t.string :name
      t.text :description

      t.text :body

      t.timestamps
    end
  end
end
