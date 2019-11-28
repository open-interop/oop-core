class AddBodiesToTransmisions < ActiveRecord::Migration[6.0]
  def change
    add_column :transmissions, :request_body, :text
    rename_column :transmissions, :body, :response_body
  end
end
