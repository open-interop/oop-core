class AddAccountIdToTemprs < ActiveRecord::Migration[6.0]
  def change
    add_column :temprs, :account_id, :integer
  end
end
