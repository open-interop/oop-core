class AddRetriedToMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :retried, :boolean
  end
end
