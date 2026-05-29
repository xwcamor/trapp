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

ActiveRecord::Schema.define(version: 2022_10_26_051406) do

  create_table "accesses", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audits", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at", precision: 6
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "bornals", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_id"
    t.date "date_rehearsal"
    t.decimal "num_bor", precision: 10
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chromatographical_dga_diags", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_id"
    t.string "eval_first"
    t.string "eval_second"
    t.string "eval_third"
    t.string "eval_fourth"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["transformer_id"], name: "fk_rails_f676d80ec4"
  end

  create_table "chromatographical_duvals", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_id"
    t.string "triangle_diag_first"
    t.string "triangle_diag_second"
    t.string "triangle_diag_third"
    t.string "pentagon_diag_first"
    t.string "pentagon_diag_second"
    t.string "pentagon_diag_third"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["transformer_id"], name: "fk_rails_300be97b3d"
  end

  create_table "chromatographicals", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_id"
    t.date "date_rehearsal"
    t.decimal "num_hid", precision: 10
    t.decimal "num_oxi", precision: 10
    t.decimal "num_nit", precision: 10
    t.decimal "num_met", precision: 10
    t.decimal "num_mon", precision: 10
    t.decimal "num_dio", precision: 10
    t.decimal "num_eti", precision: 10
    t.decimal "num_eta", precision: 10
    t.decimal "num_ace", precision: 10
    t.integer "diag_status"
    t.decimal "deleted", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transformer_id"], name: "fk_rails_819f2d7613"
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "user_id"
    t.string "description"
    t.integer "rate"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "fk_rails_2fd19c0db7"
    t.index ["user_id"], name: "fk_rails_03de2dc08c"
  end

  create_table "conmutation_types", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "connection_types", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "address"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customer_areas", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "customer_location_id"
    t.bigint "customer_id"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "fk_rails_a23977b727"
    t.index ["customer_location_id"], name: "fk_rails_fb52620c9f"
  end

  create_table "customer_locations", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "customer_id"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "fk_rails_00c1342968"
  end

  create_table "customer_substations", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "customer_area_id"
    t.bigint "customer_id"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_area_id"], name: "fk_rails_110eafad42"
    t.index ["customer_id"], name: "fk_rails_f7f406f755"
  end

  create_table "customers", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "country_id"
    t.string "name"
    t.string "num_doc"
    t.string "address"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "fk_rails_595506fbcf"
  end

  create_table "devanado_details", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "devanado_id"
    t.bigint "devanado_flow_id"
    t.date "date_devanado"
    t.decimal "col1_val", precision: 10
    t.decimal "col2_val", precision: 10
    t.decimal "col3_val", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["devanado_flow_id"], name: "fk_rails_ec7895e681"
    t.index ["devanado_id"], name: "fk_rails_631ed67cfc"
  end

  create_table "devanado_flows", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devanado_template_details", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "devanado_template_id"
    t.bigint "devanado_flow_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["devanado_flow_id"], name: "fk_rails_1109da5ad5"
    t.index ["devanado_template_id"], name: "fk_rails_9d6c6bbb4d"
  end

  create_table "devanado_template_transformers", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_id"
    t.bigint "devanado_template_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["devanado_template_id"], name: "fk_rails_690c52ec80"
    t.index ["transformer_id"], name: "fk_rails_3fb4b294c3"
  end

  create_table "devanado_templates", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "unit_name"
    t.bigint "user_id"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devanados", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_id"
    t.date "date_rehearsal"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transformer_id"], name: "fk_rails_feae7970d8"
  end

  create_table "duvals", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.integer "duval_type_id"
    t.integer "graph_type"
    t.string "name"
    t.string "short_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "electricals", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_id"
    t.date "date_rehearsal"
    t.decimal "val_a1", precision: 10
    t.decimal "va_a2", precision: 10
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "factors", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_id"
    t.date "date_rehearsal"
    t.decimal "num_fac", precision: 10
    t.integer "diag_status"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transformer_id"], name: "fk_rails_99e62751f2"
  end

  create_table "furanos", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_id"
    t.date "date_rehearsal"
    t.decimal "num_fal", precision: 10
    t.decimal "num_hme", precision: 10
    t.decimal "num_ace", precision: 10
    t.decimal "num_mfu", precision: 10
    t.decimal "num_fua", precision: 10
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transformer_id"], name: "fk_rails_d0cb305158"
  end

  create_table "gas", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_test_id"
    t.string "name"
    t.string "short_name"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transformer_test_id"], name: "fk_rails_c01e9e8363"
  end

  create_table "gas_keys", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_id"
    t.integer "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transformer_id"], name: "fk_rails_4c606cfdc1"
  end

  create_table "ieee_diag_details", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "chromatographical_id"
    t.bigint "ieee_diag_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chromatographical_id"], name: "fk_rails_05faad3b59"
    t.index ["ieee_diag_id"], name: "fk_rails_c3103ea36f"
  end

  create_table "ieee_diags", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_id"
    t.date "date_rehearsal"
    t.integer "state"
    t.integer "deleted"
    t.integer "month_period"
    t.integer "ppm_hid"
    t.integer "ppm_met"
    t.integer "ppm_mon"
    t.integer "ppm_dio"
    t.integer "ppm_eti"
    t.integer "ppm_eta"
    t.integer "ppm_ace"
    t.decimal "ratio", precision: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["transformer_id"], name: "fk_rails_57488fb01b"
  end

  create_table "marks", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meet_events", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.integer "transformer_id"
    t.string "title"
    t.datetime "start"
    t.datetime "end"
    t.string "color"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meetings", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.string "description"
    t.datetime "start"
    t.datetime "end"
    t.string "color"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "newspapers", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "description"
    t.integer "state"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oil_types", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "option_posts", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "physical_comments", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "physical_post_id"
    t.bigint "user_id"
    t.string "description"
    t.integer "rate"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["physical_post_id"], name: "fk_rails_fdf0ed924e"
    t.index ["user_id"], name: "fk_rails_02e5c07fc6"
  end

  create_table "physical_posts", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_id"
    t.bigint "user_id"
    t.bigint "physical_id"
    t.bigint "type_comment_id"
    t.string "description"
    t.integer "rate"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["physical_id"], name: "fk_rails_eaa4313563"
    t.index ["transformer_id"], name: "fk_rails_541b517cfe"
    t.index ["type_comment_id"], name: "fk_rails_9de74a2f5d"
    t.index ["user_id"], name: "fk_rails_a8b00533c7"
  end

  create_table "physical_trials", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_test_id"
    t.string "name"
    t.string "short_name"
    t.string "unit_name"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transformer_test_id"], name: "fk_rails_93adfab70b"
  end

  create_table "physicals", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_id"
    t.date "date_rehearsal"
    t.decimal "num_acid", precision: 10
    t.decimal "num_pot", precision: 10
    t.decimal "num_rig", precision: 10
    t.decimal "num_ten", precision: 10
    t.decimal "num_wat", precision: 10
    t.integer "diag_status"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transformer_id"], name: "fk_rails_1c5b61bf9a"
  end

  create_table "posts", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "transformer_id"
    t.bigint "user_id"
    t.bigint "chromatographical_id"
    t.bigint "type_comment_id"
    t.string "description"
    t.integer "rate"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chromatographical_id"], name: "fk_rails_0c9b76ecea"
    t.index ["transformer_id"], name: "fk_rails_549c81f91d"
    t.index ["type_comment_id"], name: "fk_rails_dea45cb0f4"
    t.index ["user_id"], name: "fk_rails_5b5ddfd518"
  end

  create_table "profile_accesses", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "access_id"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_id"], name: "fk_rails_7a9c39b6a9"
    t.index ["profile_id"], name: "fk_rails_bac9a50fe4"
  end

  create_table "profiles", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "report_details", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "report_id"
    t.bigint "transformer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "user_id"
    t.string "description"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "search_transformer_per_users", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "customer_id"
    t.string "transformer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transformer_preservations", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transformer_tests", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transformer_types", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "name"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transformers", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "customer_substation_id"
    t.bigint "transformer_type_id"
    t.bigint "connection_type_id"
    t.bigint "conmutation_type_id"
    t.bigint "transformer_preservation_id"
    t.bigint "oil_type_id"
    t.bigint "mark_id"
    t.string "num_serie"
    t.string "num_tag"
    t.decimal "num_vol", precision: 10
    t.decimal "num_pot", precision: 10
    t.integer "age"
    t.integer "num_fas"
    t.integer "num_tap"
    t.integer "num_health"
    t.integer "state_health"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conmutation_type_id"], name: "fk_rails_1e558ddeca"
    t.index ["connection_type_id"], name: "fk_rails_7998b4091a"
    t.index ["customer_substation_id"], name: "fk_rails_61066423e7"
    t.index ["mark_id"], name: "fk_rails_bb3d49e7df"
    t.index ["oil_type_id"], name: "fk_rails_413364a911"
    t.index ["transformer_preservation_id"], name: "fk_rails_8ead232334"
    t.index ["transformer_type_id"], name: "fk_rails_6eebe53c91"
  end

  create_table "type_comments", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "option_post_id"
    t.string "name"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_post_id"], name: "fk_rails_9abf045418"
  end

  create_table "user_customers", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "fk_rails_c50b290356"
    t.index ["user_id"], name: "fk_rails_52f4ac6e57"
  end

  create_table "user_notifications", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.integer "transformer_id"
    t.string "user_id"
    t.date "date_notification"
    t.string "description"
    t.integer "state"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_spanish_ci", force: :cascade do |t|
    t.string "num_doc"
    t.string "username"
    t.string "name"
    t.string "lastname1"
    t.string "lastname2"
    t.string "cellphone"
    t.string "email"
    t.string "real_password"
    t.string "hashed_password"
    t.string "salt"
    t.bigint "profile_id"
    t.string "customer_id"
    t.string "country_id"
    t.datetime "password_reset_token_date"
    t.datetime "password_reset_change_date"
    t.string   "password_reset_token"
    t.datetime "password_expires_after"
    t.string "authentication_token"
    t.datetime "last_signed_in_on"
    t.datetime "signed_up_on"
    t.integer "state"
    t.integer "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.index ["profile_id"], name: "fk_rails_a8794354f0"
  end

  add_foreign_key "chromatographical_dga_diags", "transformers"
  add_foreign_key "chromatographical_duvals", "transformers"
  add_foreign_key "chromatographicals", "transformers"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "customer_areas", "customer_locations"
  add_foreign_key "customer_areas", "customers"
  add_foreign_key "customer_locations", "customers"
  add_foreign_key "customer_substations", "customer_areas"
  add_foreign_key "customer_substations", "customers"
  add_foreign_key "customers", "countries"
  add_foreign_key "devanado_details", "devanado_flows"
  add_foreign_key "devanado_details", "devanados"
  add_foreign_key "devanado_template_details", "devanado_flows"
  add_foreign_key "devanado_template_details", "devanado_templates"
  add_foreign_key "devanado_template_transformers", "devanado_templates"
  add_foreign_key "devanado_template_transformers", "transformers"
  add_foreign_key "devanados", "transformers"
  add_foreign_key "factors", "transformers"
  add_foreign_key "furanos", "transformers"
  add_foreign_key "gas", "transformer_tests"
  add_foreign_key "gas_keys", "transformers"
  add_foreign_key "ieee_diag_details", "chromatographicals"
  add_foreign_key "ieee_diag_details", "ieee_diags"
  add_foreign_key "ieee_diags", "transformers"
  add_foreign_key "physical_comments", "physical_posts"
  add_foreign_key "physical_comments", "users"
  add_foreign_key "physical_posts", "physicals"
  add_foreign_key "physical_posts", "transformers"
  add_foreign_key "physical_posts", "type_comments"
  add_foreign_key "physical_posts", "users"
  add_foreign_key "physical_trials", "transformer_tests"
  add_foreign_key "physicals", "transformers"
  add_foreign_key "posts", "chromatographicals"
  add_foreign_key "posts", "transformers"
  add_foreign_key "posts", "type_comments"
  add_foreign_key "posts", "users"
  add_foreign_key "profile_accesses", "accesses"
  add_foreign_key "profile_accesses", "profiles"
  add_foreign_key "transformers", "conmutation_types"
  add_foreign_key "transformers", "connection_types"
  add_foreign_key "transformers", "customer_substations"
  add_foreign_key "transformers", "marks"
  add_foreign_key "transformers", "oil_types"
  add_foreign_key "transformers", "transformer_preservations"
  add_foreign_key "transformers", "transformer_types"
  add_foreign_key "type_comments", "option_posts"
  add_foreign_key "user_customers", "customers"
  add_foreign_key "user_customers", "users"
  add_foreign_key "users", "profiles"
end
