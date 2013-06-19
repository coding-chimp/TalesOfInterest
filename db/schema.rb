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

ActiveRecord::Schema.define(:version => 20130619174325) do

  create_table "audio_files", :force => true do |t|
    t.string   "url"
    t.string   "media_type"
    t.integer  "size"
    t.integer  "episode_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "blogrolls", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "chapters", :force => true do |t|
    t.integer  "timestamp"
    t.string   "title"
    t.integer  "episode_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "download_data", :force => true do |t|
    t.date     "date"
    t.integer  "audio_file_id"
    t.integer  "downloaded",    :limit => 8
    t.integer  "hits"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "episodes", :force => true do |t|
    t.integer  "number"
    t.string   "title"
    t.text     "description"
    t.integer  "playtime"
    t.boolean  "explicit"
    t.integer  "podcast_id"
    t.string   "slug"
    t.datetime "published_at"
    t.boolean  "draft",            :default => true
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "spotify_playlist"
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "introduced_titles", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "episode_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "footer"
  end

  create_table "podcasts", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "artwork_file_name"
    t.string   "artwork_content_type"
    t.integer  "artwork_file_size"
    t.datetime "artwork_updated_at"
    t.string   "author"
    t.string   "keywords"
    t.boolean  "explicit"
    t.string   "itunes_link"
    t.string   "category1"
    t.string   "category2"
    t.string   "category3"
    t.string   "slug"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "site_name"
    t.integer  "posts_per_page"
    t.string   "favicon_file_name"
    t.string   "favicon_content_type"
    t.integer  "favicon_file_size"
    t.datetime "favicon_updated_at"
    t.string   "ga_code"
    t.string   "flattr_code"
    t.string   "feed_language"
    t.string   "feed_email"
    t.string   "feed_author"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "uri_key"
    t.string   "uri_token"
    t.string   "gauges"
    t.string   "gauges_key"
    t.string   "qloudstat_api_key"
    t.string   "qloudstat_api_secret"
  end

  create_table "show_notes", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "episode_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "position"
  end

  create_table "subscribers", :force => true do |t|
    t.date     "date"
    t.integer  "count"
    t.string   "reader"
    t.integer  "podcast_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "traffics", :force => true do |t|
    t.integer  "views"
    t.integer  "people"
    t.date     "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",               :default => "", :null => false
    t.string   "encrypted_password",  :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
