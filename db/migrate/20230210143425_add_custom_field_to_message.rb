class AddCustomFieldToMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :custom_field_a, :string
    add_column :messages, :custom_field_b, :string
  end
end
