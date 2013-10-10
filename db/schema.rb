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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131009120941) do

  create_table "cases", :force => true do |t|
    t.string   "classname",                   :null => false
    t.string   "name",                        :null => false
    t.float    "time",       :default => 0.0
    t.string   "paste"
    t.integer  "suite_id"
    t.string   "tracker"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "message"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "results", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "message"
    t.integer  "case_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "suites", :force => true do |t|
    t.text     "build"
    t.text     "description"
    t.integer  "user_id"
    t.string   "paste"
    t.string   "tempest"
    t.integer  "total_tests",    :default => 0
    t.integer  "total_errors",   :default => 0
    t.integer  "total_failures", :default => 0
    t.integer  "total_skip",     :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "name"
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "persistence_token",                 :null => false
    t.string   "perishable_token",                  :null => false
    t.string   "crypted_password",                  :null => false
    t.string   "password_salt",                     :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

end
