class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.integer :account_id

      t.string :name

      t.boolean :active, default: true

      t.string :minute, default: '*'
      t.string :hour, default: '*'
      t.string :day_of_week, default: '*'
      t.string :day_of_month, default: '*'
      t.string :month_of_year, default: '*'
      t.string :year, default: '*'

      t.timestamps
    end
  end
end
