class AddFullNameToSites < ActiveRecord::Migration[6.0]
  def change
    add_column :sites, :full_name, :string
  end
end
