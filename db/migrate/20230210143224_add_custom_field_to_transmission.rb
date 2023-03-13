class AddCustomFieldToTransmission < ActiveRecord::Migration[6.1]
  def change
    add_column :transmissions, :custom_field_a, :string
    add_column :transmissions, :custom_field_b, :string
  end
end
