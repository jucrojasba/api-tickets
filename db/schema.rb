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

ActiveRecord::Schema[7.2].define(version: 2024_11_26_171139) do
  create_table "statuses", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_logs", force: :cascade do |t|
    t.integer "ticket_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status_id", null: false
    t.index ["status_id"], name: "index_ticket_logs_on_status_id"
    t.index ["ticket_id"], name: "index_ticket_logs_on_ticket_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "event_id", null: false
    t.date "expire_date", null: false
    t.integer "status_id", default: 1, null: false
    t.string "serial_ticket"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serial_ticket"], name: "index_tickets_on_serial_ticket", unique: true
    t.index ["status_id"], name: "index_tickets_on_status_id"
  end

  add_foreign_key "ticket_logs", "statuses"
  add_foreign_key "ticket_logs", "tickets"
  add_foreign_key "tickets", "statuses"
end
