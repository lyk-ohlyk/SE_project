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

ActiveRecord::Schema.define(version: 20180111054802) do

  create_table "assignments", force: :cascade do |t|
    t.string "title"
    t.string "deadline"
    t.string "state"
    t.string "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "course_id"
    t.index ["course_id", "created_at"], name: "index_assignments_on_course_id_and_created_at"
  end

  create_table "comments", force: :cascade do |t|
    t.string "content"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "course_code"
    t.string "course_time"
    t.string "course_name"
    t.string "score"
    t.string "exam_date"
    t.string "exam_hour"
    t.string "exam_place"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "site_id"
  end

  create_table "microposts", force: :cascade do |t|
    t.string "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
  end

  create_table "relatecourses", force: :cascade do |t|
    t.integer "learner_id"
    t.integer "lesson_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["learner_id", "lesson_id"], name: "index_relatecourses_on_learner_id_and_lesson_id", unique: true
    t.index ["learner_id"], name: "index_relatecourses_on_learner_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "student_ids", force: :cascade do |t|
    t.string "number"
    t.string "pwd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "password_digest"
    t.string "remember_token"
    t.boolean "admin", default: false
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

end
