class AddTemplateableToTemprs < ActiveRecord::Migration[6.0]
  def change
    add_reference :temprs, :templateable, polymorphic: true
  end
end
