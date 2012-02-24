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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120223070526) do

  create_table "accounts", :force => true do |t|
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gid"
  end

  create_table "accounts_monthstats", :id => false, :force => true do |t|
    t.integer "account_id"
    t.integer "monthstat_id"
  end

  create_table "dailystats", :force => true do |t|
    t.integer  "day_id"
    t.integer  "account_id"
    t.integer  "account_size", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "monthstat_id"
  end

  create_table "days", :force => true do |t|
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_count",            :default => 0
    t.integer  "users_account_size_sum", :default => 0
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "monthstats", :force => true do |t|
    t.integer  "report_id"
    t.integer  "account_id"
    t.string   "userid"
    t.string   "gid"
    t.string   "path"
    t.integer  "days"
    t.decimal  "avg_account_size",    :precision => 12, :scale => 2
    t.date     "day_of_registration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
