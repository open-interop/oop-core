class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :hostname

      t.boolean :active, default: true

      t.integer :owner_id

      t.timestamps
    end
  end
end
