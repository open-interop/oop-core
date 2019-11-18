class AddTemprIdToTemprs < ActiveRecord::Migration[6.0]
  def change
    add_column :temprs, :tempr_id, :integer
  end
end
