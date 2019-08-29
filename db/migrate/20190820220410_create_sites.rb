class CreateSites < ActiveRecord::Migration[6.0]
  def change
    create_table :sites do |t|
      t.integer :account_id
      t.integer :site_id

      t.string :name
      t.text :description

      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.string :region

      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.string :time_zone

      t.text :external_uuids

      t.timestamps
    end
  end
end
