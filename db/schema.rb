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

ActiveRecord::Schema.define(version: 20151027173435) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "celebrities", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "imdb_url"
    t.string   "wikipedia_url"
    t.integer  "twitter_followers",   limit: 8
    t.string   "industry"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "imdb_bio"
    t.string   "wikipedia_bio"
    t.string   "status",                        default: "active"
    t.integer  "shop_id"
    t.string   "shopify_url"
    t.integer  "youtube_subscribers", limit: 8
    t.integer  "instagram_followers", limit: 8
    t.string   "twitter_bio"
    t.string   "twitter_url"
    t.string   "youtube_bio"
    t.string   "youtube_url"
    t.string   "angellist_bio"
    t.string   "angellist_url"
    t.string   "linkedin_bio"
    t.string   "linkedin_url"
    t.string   "instagram_id"
    t.integer  "klout_id",            limit: 8
    t.integer  "klout_score"
    t.string   "klout_url"
    t.integer  "youtube_views",       limit: 8
    t.string   "youtube_username"
    t.string   "instagram_url"
    t.integer  "shopify_id"
  end

  add_index "celebrities", ["shop_id"], name: "index_celebrities_on_shop_id", using: :btree

  create_table "customer_records", force: :cascade do |t|
    t.integer "shop_id"
    t.integer "count",   default: 0
    t.date    "date"
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "shopify_id",          limit: 8
    t.integer  "shop_id"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "imdb_url"
    t.string   "imdb_bio"
    t.string   "wikipedia_url"
    t.string   "wikipedia_bio"
    t.string   "twitter_url"
    t.string   "twitter_bio"
    t.integer  "twitter_followers",   limit: 8
    t.string   "youtube_url"
    t.string   "youtube_bio"
    t.integer  "youtube_subscribers", limit: 8
    t.integer  "youtube_views",       limit: 8
    t.string   "youtube_username"
    t.string   "angellist_bio"
    t.string   "angellist_url"
    t.string   "linkedin_bio"
    t.string   "linkedin_url"
    t.integer  "klout_id",            limit: 8
    t.integer  "klout_score"
    t.string   "klout_url"
    t.integer  "instagram_followers", limit: 8
    t.string   "instagram_id"
    t.string   "instagram_url"
    t.string   "shopify_url"
    t.string   "status",                        default: "regular"
    t.boolean  "archived",                      default: false
    t.boolean  "scanned_on_social",             default: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain",                                null: false
    t.string   "shopify_token",                                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "twitter_follower_threshold",   default: 1000
    t.boolean  "email_notifications",          default: true
    t.boolean  "installed",                    default: false
    t.string   "email"
    t.boolean  "wikipedia_notification",       default: true
    t.boolean  "imdb_notification",            default: false
    t.integer  "youtube_subscriber_threshold", default: 1000
    t.integer  "instagram_follower_threshold", default: 1000
    t.integer  "klout_score_threshold",        default: 75
    t.string   "plan",                         default: "free"
    t.integer  "charge_id"
    t.boolean  "teaser_celebrity",             default: false
  end

  add_index "shops", ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true, using: :btree

  add_foreign_key "celebrities", "shops"
end
