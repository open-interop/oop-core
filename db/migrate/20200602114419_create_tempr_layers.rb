class CreateTemprLayers < ActiveRecord::Migration[6.0]
  def change
    create_table :tempr_layers do |t|
      t.integer :tempr_id
      t.integer :layer_id

      t.timestamps
    end
  end
end
