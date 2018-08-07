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

ActiveRecord::Schema.define(version: 2018_08_07_144141) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "applications", force: :cascade do |t|
    t.integer "candidate_id"
    t.boolean "prospect", default: false
    t.datetime "applied_at"
    t.datetime "rejected_at"
    t.datetime "last_activity_at"
    t.json "location"
    t.json "source"
    t.json "credited_to"
    t.json "rejection_reason"
    t.json "rejection_details"
    t.json "jobs", array: true
    t.string "status"
    t.json "current_stage"
    t.json "answers", array: true
    t.json "prospect_detail"
    t.json "custom_fields"
    t.json "keyed_custom_fields"
  end

  create_table "candidates", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "company"
    t.string "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_activity"
    t.boolean "is_private"
    t.string "photo_url"
    t.json "attachments", array: true
    t.integer "application_ids", array: true
    t.json "phone_numbers", array: true
    t.json "addresses", array: true
    t.json "email_addresses", array: true
    t.json "website_addresses", array: true
    t.json "social_media_addresses", array: true
    t.json "recruiter"
    t.json "coordinator"
    t.string "tags", array: true
    t.json "applications", array: true
    t.json "educations", array: true
    t.json "employments", array: true
    t.json "custom_fields"
    t.json "keyed_custom_fields"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.integer "child_ids", array: true
    t.string "external_id"
  end

  create_table "job_openings", force: :cascade do |t|
    t.string "opening_id"
    t.string "status"
    t.datetime "opened_at"
    t.datetime "closed_at"
    t.integer "application_id"
    t.json "close_reason"
    t.integer "job_id"
  end

  create_table "job_posts", force: :cascade do |t|
    t.string "title"
    t.json "location"
    t.boolean "internal"
    t.boolean "external"
    t.boolean "active"
    t.boolean "live"
    t.integer "job_id"
    t.string "content"
    t.string "internal_content"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.json "questions", array: true
  end

  create_table "jobs", force: :cascade do |t|
    t.string "name"
    t.string "requisition_id"
    t.string "notes"
    t.boolean "confidential"
    t.string "status"
    t.datetime "created_at"
    t.datetime "opened_at"
    t.datetime "closed_at"
    t.json "departments", array: true
    t.json "offices", array: true
    t.json "custom_fields"
    t.json "keyed_custom_fields"
    t.json "hiring_team"
    t.json "openings", array: true
    t.integer "department_id"
  end

  create_table "offers", force: :cascade do |t|
    t.integer "version"
    t.integer "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
    t.datetime "resolved_at"
    t.datetime "starts_at"
    t.string "status"
    t.json "custom_fields"
    t.json "keyed_custom_fields"
    t.integer "job_id"
  end

  create_table "ui_helpers", force: :cascade do |t|
    t.string "name"
    t.datetime "last_updated"
    t.boolean "updating"
    t.index ["name"], name: "index_ui_helpers_on_name"
  end

end
