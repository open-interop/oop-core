class CreateBlacklistEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :blacklist_entries do |t|
      t.integer :account_id

      t.string :ip_literal
      t.string :ip_range
      t.string :path_literal
      t.string :path_regex
      t.string :headers

      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
