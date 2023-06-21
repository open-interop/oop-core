class AddIndexMessages < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key(:messages, :schedules, if_not_exists: true)
    add_index(:messages, :schedule_id, unique: false)

    add_foreign_key(:messages, :devices, if_not_exists: true)
    add_index(:messages, :device_id, unique: false)

    add_index(:messages, :created_at, unique: false)
    add_index(:messages, :retried_at, unique: false)

    add_index(:messages, [:origin_id, :origin_type])
  end
end
