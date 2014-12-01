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

ActiveRecord::Schema.define(version: 20141201042155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "converted_pull_requests", force: true do |t|
    t.integer  "note_id",         null: false
    t.integer  "project_id",      null: false
    t.integer  "pull_request_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "converted_pull_requests", ["note_id"], name: "index_converted_pull_requests_on_note_id", using: :btree
  add_index "converted_pull_requests", ["project_id"], name: "index_converted_pull_requests_on_project_id", using: :btree
  add_index "converted_pull_requests", ["pull_request_id"], name: "index_converted_pull_requests_on_pull_request_id", using: :btree

  create_table "notes", force: true do |t|
    t.text     "title",         default: "", null: false
    t.string   "level",                      null: false
    t.text     "markdown_body", default: "", null: false
    t.integer  "project_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
    t.datetime "published_at"
  end

  add_index "notes", ["project_id"], name: "index_notes_on_project_id", using: :btree

  create_table "notes_reports", force: true do |t|
    t.integer  "note_id",    null: false
    t.integer  "report_id",  null: false
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes_reports", ["note_id", "report_id"], name: "index_notes_reports_on_note_id_and_report_id", unique: true, using: :btree
  add_index "notes_reports", ["note_id"], name: "index_notes_reports_on_note_id", using: :btree
  add_index "notes_reports", ["report_id"], name: "index_notes_reports_on_report_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "title",      null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "reports", force: true do |t|
    t.string   "name",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",  default: false
    t.integer  "project_id",                 null: false
  end

  add_index "reports", ["project_id"], name: "index_reports_on_project_id", using: :btree

  create_table "repositories", force: true do |t|
    t.string   "full_name",      null: false
    t.boolean  "private",        null: false
    t.text     "url",            null: false
    t.string   "default_branch", null: false
    t.integer  "github_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id",     null: false
    t.string   "owner",          null: false
    t.string   "repo",           null: false
  end

  create_table "teams", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",               default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "github_token"
    t.string   "github_uid"
    t.string   "name"
    t.string   "nickname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  add_index "users", ["team_id"], name: "index_users_on_team_id", using: :btree

end
