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

ActiveRecord::Schema.define(:version => 20131008094456) do

  create_table "cases", :force => true do |t|
    t.string   "classname",                   :null => false
    t.string   "name",                        :null => false
    t.float    "time",       :default => 0.0
    t.integer  "suite_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
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
    t.string   "tempest"
    t.integer  "total_tests",    :default => 0
    t.integer  "total_errors",   :default => 0
    t.integer  "total_failures", :default => 0
    t.integer  "total_skip",     :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

end
