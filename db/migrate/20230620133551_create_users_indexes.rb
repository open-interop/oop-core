class CreateUsersIndexes < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key(:users, :accounts, if_not_exists: true)
    add_index(:users, :account_id, unique: false)

    add_index(:users, :created_at, unique: false)
  end
end
