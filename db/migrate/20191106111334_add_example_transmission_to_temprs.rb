class AddExampleTransmissionToTemprs < ActiveRecord::Migration[6.0]
  def change
    add_column :temprs, :example_transmission, :text
  end
end
