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

ActiveRecord::Schema[8.0].define(version: 2025_03_05_191438) do
  create_table "itineraries", force: :cascade do |t|
    t.string "based_iata"
    t.string "raw_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "segments", force: :cascade do |t|
    t.integer "itinerary_id"
    t.string "segment_type", null: false
    t.string "from"
    t.string "to"
    t.string "on"
    t.date "from_date"
    t.time "from_time"
    t.date "to_date"
    t.time "to_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["itinerary_id"], name: "index_segments_on_itinerary_id"
  end

  add_foreign_key "segments", "itineraries"
end
