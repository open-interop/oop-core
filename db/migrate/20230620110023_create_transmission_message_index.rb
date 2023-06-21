class CreateTransmissionMessageIndex < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key(:transmissions, :messages, if_not_exists: true)
    add_index(:transmissions, :message_id, unique: false)

    add_foreign_key(:transmissions, :accounts, if_not_exists: true)
    add_index(:transmissions, :account_id, unique: false)

    add_foreign_key(:transmissions, :devices, if_not_exists: true)
    add_index(:transmissions, :device_id, unique: false)

    add_index(:transmissions, :created_at, unique: false)
    add_index(:transmissions, :retried_at, unique: false)
  end
end
