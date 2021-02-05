class AddStatusToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :state, :string, default: 'unknown'
  end
end
