class CreateTemprTemplate < ActiveRecord::Migration[6.0]
  def change
    create_table :tempr_templates do |t|
      t.text :temprs

      t.timestamps
    end
  end
end
