class AddConsoleOutputToTransmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :transmissions, :console_output, :text
  end
end
