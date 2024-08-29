# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_29_084024) do
  create_table "authentications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "genres", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memo_tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "memo_id"
    t.integer "tag_id"
  end

  create_table "memos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "progress", default: false
    t.index ["user_id"], name: "index_memos_on_user_id"
  end

  create_table "reflection_memo_memos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "reflection_memo_id"
    t.bigint "memo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["memo_id"], name: "index_reflection_memo_memos_on_memo_id"
    t.index ["reflection_memo_id"], name: "index_reflection_memo_memos_on_reflection_memo_id"
  end

  create_table "reflection_memos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.text "content"
    t.boolean "progress", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "feedback_given", default: ""
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "line_user_id"
    t.string "profile_image_url"
    t.index ["line_user_id"], name: "index_users_on_line_user_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "memos", "users"
  add_foreign_key "reflection_memo_memos", "memos"
  add_foreign_key "reflection_memo_memos", "reflection_memos"
end
