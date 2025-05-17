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

ActiveRecord::Schema[7.2].define(version: 2025_05_17_111825) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ingredients", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "name"
    t.string "amount"
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "display_amount"
    t.string "category"
    t.index ["recipe_id"], name: "index_ingredients_on_recipe_id"
  end

  create_table "nutrition_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "unit", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_nutrition_types_on_name", unique: true
  end

  create_table "prices", force: :cascade do |t|
    t.bigint "vegetable_id", null: false
    t.integer "price", null: false
    t.string "market", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vegetable_id", "market", "date"], name: "index_prices_on_vegetable_id_and_market_and_date", unique: true
    t.index ["vegetable_id"], name: "index_prices_on_vegetable_id"
  end

  create_table "recipe_steps", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.integer "step_number"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id", "step_number"], name: "index_recipe_steps_on_recipe_id_and_step_number", unique: true
    t.index ["recipe_id"], name: "index_recipe_steps_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.text "instructions"
    t.integer "cooking_time"
    t.string "difficulty"
    t.integer "servings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "recipe_category"
    t.integer "calorie"
    t.string "cooking_method"
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.bigint "vegetable_id", null: false
    t.integer "start_month"
    t.integer "end_month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "note"
    t.index ["vegetable_id"], name: "index_seasons_on_vegetable_id"
  end

  create_table "shopping_list_items", force: :cascade do |t|
    t.bigint "shopping_list_id", null: false
    t.bigint "recipe_id", null: false
    t.bigint "ingredient_id", null: false
    t.boolean "checked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_shopping_list_items_on_ingredient_id"
    t.index ["recipe_id"], name: "index_shopping_list_items_on_recipe_id"
    t.index ["shopping_list_id", "ingredient_id"], name: "idx_on_shopping_list_id_ingredient_id_f6963fd74f", unique: true
    t.index ["shopping_list_id"], name: "index_shopping_list_items_on_shopping_list_id"
  end

  create_table "shopping_lists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_shopping_lists_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "vegetable_nutritions", force: :cascade do |t|
    t.bigint "vegetable_id", null: false
    t.bigint "nutrition_type_id", null: false
    t.decimal "amount", precision: 6, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nutrition_type_id"], name: "index_vegetable_nutritions_on_nutrition_type_id"
    t.index ["vegetable_id", "nutrition_type_id"], name: "idx_on_vegetable_id_nutrition_type_id_fceaa12b73", unique: true
    t.index ["vegetable_id"], name: "index_vegetable_nutritions_on_vegetable_id"
  end

  create_table "vegetables", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "origin"
    t.string "storage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.index ["name"], name: "index_vegetables_on_name", unique: true
  end

  add_foreign_key "ingredients", "recipes"
  add_foreign_key "prices", "vegetables"
  add_foreign_key "recipe_steps", "recipes"
  add_foreign_key "recipes", "users"
  add_foreign_key "seasons", "vegetables"
  add_foreign_key "shopping_list_items", "ingredients"
  add_foreign_key "shopping_list_items", "recipes"
  add_foreign_key "shopping_list_items", "shopping_lists"
  add_foreign_key "shopping_lists", "users"
  add_foreign_key "vegetable_nutritions", "nutrition_types"
  add_foreign_key "vegetable_nutritions", "vegetables"
end
