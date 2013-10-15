# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131020124321) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "cases", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "classname",                     null: false
    t.string   "name",                          null: false
    t.float    "time",            default: 0.0
    t.string   "paste"
    t.uuid     "suite_id"
    t.string   "tracker"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "tracker_user_id"
  end

  create_table "members", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "user_id"
    t.boolean  "owner",      default: "false"
    t.uuid     "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.uuid     "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "message"
    t.uuid     "case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suites", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.text     "build"
    t.text     "description"
    t.string   "paste"
    t.string   "tempest"
    t.integer  "total_tests",    default: 0
    t.integer  "total_errors",   default: 0
    t.integer  "total_failures", default: 0
    t.integer  "total_skip",     default: 0
    t.uuid     "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "project_id"
    t.integer  "total_passed"
  end

  create_table "taggings", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "tag_id"
    t.uuid     "taggable_id"
    t.string   "taggable_type"
    t.uuid     "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string "name"
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.boolean  "active",             default: "false"
    t.integer  "login_count",        default: 0,       null: false
    t.integer  "failed_login_count", default: 0,       null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.boolean  "admin",              default: "false"
    t.string   "persistence_token",                    null: false
    t.string   "perishable_token",                     null: false
    t.string   "crypted_password",                     null: false
    t.string   "password_salt",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
