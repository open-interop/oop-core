class AddNotesToTemprs < ActiveRecord::Migration[6.0]
  def change
    add_column :temprs, :notes, :text
  end
end
