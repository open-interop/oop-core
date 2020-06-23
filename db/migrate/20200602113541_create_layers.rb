class CreateLayers < ActiveRecord::Migration[6.0]
  def change
    create_table :layers do |t|
      t.integer :account_id

      t.string :name
      t.string :reference
      t.text :script

      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
