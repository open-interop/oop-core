class AddRetriedAtToMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :retried_at, :datetime
  end
end
