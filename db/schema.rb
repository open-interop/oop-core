# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_02_28_172552) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "hostname"
    t.boolean "active", default: true
    t.integer "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "interface_scheme"
    t.integer "interface_port"
    t.string "interface_path"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "blacklist_entries", force: :cascade do |t|
    t.integer "account_id"
    t.string "ip_literal"
    t.string "ip_range"
    t.string "path_literal"
    t.string "path_regex"
    t.string "headers"
    t.boolean "archived", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "device_groups", force: :cascade do |t|
    t.integer "account_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "device_temprs", force: :cascade do |t|
    t.integer "device_id"
    t.integer "tempr_id"
    t.string "endpoint_type"
    t.boolean "queue_response"
    t.text "options"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
  end

  create_table "devices", force: :cascade do |t|
    t.integer "account_id"
    t.integer "device_group_id"
    t.integer "site_id"
    t.string "name"
    t.text "authentication_headers"
    t.text "authentication_query"
    t.string "authentication_path"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "time_zone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: true
    t.boolean "queue_messages", default: false
  end

  create_table "http_templates", force: :cascade do |t|
    t.text "host"
    t.text "port"
    t.text "path"
    t.text "protocol"
    t.text "request_method"
    t.text "headers"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "layers", force: :cascade do |t|
    t.integer "account_id"
    t.string "name"
    t.string "reference"
    t.text "script"
    t.boolean "archived", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "account_id"
    t.integer "device_id"
    t.integer "schedule_id"
    t.string "uuid"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "origin_id"
    t.string "origin_type"
    t.integer "transmission_count", default: 0
    t.string "ip_address"
    t.string "state", default: "unknown"
    t.string "custom_field_a"
    t.string "custom_field_b"
    t.datetime "retried_at"
    t.boolean "retried"
    t.index ["account_id"], name: "index_messages_on_account_id"
  end

  create_table "schedule_temprs", force: :cascade do |t|
    t.integer "tempr_id"
    t.integer "schedule_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "account_id"
    t.string "name"
    t.boolean "active", default: true
    t.string "minute", default: "*"
    t.string "hour", default: "*"
    t.string "day_of_week", default: "*"
    t.string "day_of_month", default: "*"
    t.string "month_of_year", default: "*"
    t.string "year", default: "*"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "queue_messages", default: false
  end

  create_table "sites", force: :cascade do |t|
    t.integer "account_id"
    t.integer "site_id"
    t.string "name"
    t.text "description"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country"
    t.string "region"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "time_zone"
    t.text "external_uuids"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "full_name"
  end

  create_table "tempr_layers", force: :cascade do |t|
    t.integer "tempr_id"
    t.integer "layer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tempr_templates", force: :cascade do |t|
    t.text "temprs"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "temprs", force: :cascade do |t|
    t.integer "device_group_id"
    t.string "name"
    t.text "description"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "account_id"
    t.string "endpoint_type"
    t.boolean "queue_response", default: false
    t.boolean "queue_request", default: false
    t.text "template"
    t.text "example_transmission"
    t.integer "tempr_id"
    t.text "notes"
    t.string "templateable_type"
    t.bigint "templateable_id"
    t.index ["templateable_type", "templateable_id"], name: "index_temprs_on_templateable_type_and_templateable_id"
  end

  create_table "transmissions", force: :cascade do |t|
    t.integer "device_id"
    t.string "message_uuid"
    t.string "transmission_uuid"
    t.boolean "success"
    t.integer "status"
    t.datetime "transmitted_at"
    t.text "response_body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "request_body"
    t.integer "schedule_id"
    t.integer "tempr_id"
    t.integer "account_id"
    t.integer "message_id"
    t.string "state"
    t.boolean "discarded", default: false
    t.string "custom_field_a"
    t.string "custom_field_b"
    t.datetime "retried_at"
    t.boolean "retried"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "account_id"
    t.string "time_zone", default: "London"
    t.string "password_reset_token"
    t.datetime "password_reset_requested_at"
    t.string "first_name"
    t.string "last_name"
    t.text "description"
    t.string "job_title"
    t.date "date_of_birth"
  end

  add_foreign_key "messages", "accounts"
end
