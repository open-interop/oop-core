# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :account, foreign_key: true
      t.integer :device_id
      t.integer :schedule_id

      t.string :uuid

      t.text :body

      t.timestamps
    end
  end
end
