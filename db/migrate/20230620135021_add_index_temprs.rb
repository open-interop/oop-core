class AddIndexTemprs < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key(:temprs, :accounts, if_not_exists: true)
    add_index(:temprs, :account_id, unique: false)

    add_foreign_key(:temprs, :device_groups, if_not_exists: true)
    add_index(:temprs, :device_group_id, unique: false)

    add_foreign_key(:temprs, :temprs, if_not_exists: true)
    add_index(:temprs, :tempr_id, unique: false)

    add_index(:temprs, :created_at, unique: false)
  end
end
