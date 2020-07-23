class CreateHttpTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :http_templates do |t|
      t.text :host
      t.text :port
      t.text :path
      t.text :protocol
      t.text :request_method
      t.text :headers
      t.text :body

      t.timestamps
    end
  end
end
