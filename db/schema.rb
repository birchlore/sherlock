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

ActiveRecord::Schema.define(version: 20150928211956) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "celebrities", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "imdb_url"
    t.string   "wikipedia_url"
    t.integer  "twitter_followers"
    t.string   "industry"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "imdb_bio"
    t.string   "wikipedia_bio"
    t.string   "status",              default: "active"
    t.integer  "shop_id"
    t.string   "shopify_url"
    t.integer  "youtube_subscribers"
    t.integer  "instagram_followers"
    t.string   "twitter_bio"
    t.string   "twitter_url"
    t.string   "youtube_bio"
    t.string   "youtube_url"
    t.string   "angellist_bio"
    t.string   "angellist_url"
    t.string   "linkedin_bio"
    t.string   "linkedin_url"
    t.string   "instagram_id"
    t.integer  "klout_id"
    t.float    "klout_score"
    t.string   "klout_url"
    t.integer  "youtube_views"
    t.string   "youtube_username"
  end

  add_index "celebrities", ["shop_id"], name: "index_celebrities_on_shop_id", using: :btree

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain",                             null: false
    t.string   "shopify_token",                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "twitter_follower_threshold", default: 2500
    t.boolean  "email_notifications",        default: true
    t.boolean  "installed",                  default: false
    t.string   "email"
    t.boolean  "wikipedia_notification",     default: true
    t.boolean  "imdb_notification",          default: false
  end

  add_index "shops", ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true, using: :btree

  add_foreign_key "celebrities", "shops"
end
