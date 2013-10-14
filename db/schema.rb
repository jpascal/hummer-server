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

ActiveRecord::Schema.define(version: 20131012131150) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "cases", id: false, force: true do |t|
    t.uuid     "id",                       null: false
    t.string   "classname",                null: false
    t.string   "name",                     null: false
    t.float    "time",       default: 0.0
    t.string   "paste"
    t.uuid     "suite_id"
    t.string   "tracker"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", id: false, force: true do |t|
    t.uuid     "id",                         null: false
    t.uuid     "user_id"
    t.boolean  "owner",      default: false
    t.uuid     "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", id: false, force: true do |t|
    t.uuid     "id",         null: false
    t.string   "name"
    t.uuid     "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", id: false, force: true do |t|
    t.uuid     "id",         null: false
    t.string   "type"
    t.string   "name"
    t.text     "message"
    t.uuid     "case_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suites", id: false, force: true do |t|
    t.uuid     "id",                         null: false
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
  end

  create_table "users", id: false, force: true do |t|
    t.uuid     "id",                                 null: false
    t.string   "email"
    t.string   "name"
    t.boolean  "active",             default: false
    t.integer  "login_count",        default: 0,     null: false
    t.integer  "failed_login_count", default: 0,     null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.boolean  "admin",              default: false
    t.string   "persistence_token",                  null: false
    t.string   "perishable_token",                   null: false
    t.string   "crypted_password",                   null: false
    t.string   "password_salt",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
