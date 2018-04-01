# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180401192136) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "artist"
  end

  create_table "artists", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "scrobble_tracks", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "artist"
    t.string "album"
    t.integer "track"
  end

  create_table "scrobbles", force: :cascade do |t|
    t.string "artist"
    t.string "album"
    t.string "name"
    t.datetime "time"
    t.integer "length"
    t.bigint "scrobble_track_id"
    t.bigint "user_id"
    t.index ["scrobble_track_id"], name: "index_scrobbles_on_scrobble_track_id"
    t.index ["user_id"], name: "index_scrobbles_on_user_id"
  end

  create_table "sessions", id: false, force: :cascade do |t|
    t.string "id"
    t.string "client", limit: 3
    t.string "sessionid", limit: 32
    t.datetime "expires"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tracks", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "artist"
    t.string "album"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", limit: 64
    t.string "password", limit: 32
  end

end
