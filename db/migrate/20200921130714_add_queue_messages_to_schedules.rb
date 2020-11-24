class AddQueueMessagesToSchedules < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :queue_messages, :boolean, default: false
  end
end
