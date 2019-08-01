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

ActiveRecord::Schema.define(version: 2019_06_09_030046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "github_comments", force: :cascade do |t|
    t.string "body"
    t.string "html_url"
    t.boolean "status"
    t.string "state"
    t.string "author_name"
    t.string "pr_url"
    t.string "thread_ts"
  end

  create_table "pull_requests", force: :cascade do |t|
    t.string "url"
    t.string "author_id"
    t.string "author_user_name"
    t.string "thread_ts"
    t.string "channel"
    t.string "channel_id"
  end

end
