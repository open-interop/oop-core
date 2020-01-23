class CreateScheduleTempr < ActiveRecord::Migration[6.0]
  def change
    create_table :schedule_temprs do |t|
      t.integer :tempr_id
      t.integer :schedule_id

      t.timestamps
    end
  end
end
