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

ActiveRecord::Schema.define(:version => 20120826103525) do

  create_table "hospitals", :force => true do |t|
    t.string   "name"
    t.string   "namefull"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "patients", :force => true do |t|
    t.string   "name_f"
    t.string   "name_i"
    t.string   "name_o"
    t.integer  "sex"
    t.date     "birth_date"
    t.string   "address"
    t.string   "work_place"
    t.string   "work_position"
    t.string   "description"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "before_invalid"
    t.string   "before_invalid_descr"
    t.decimal  "weight"
    t.decimal  "height"
    t.decimal  "imt"
    t.decimal  "imt_cond"
    t.integer  "is_nasled"
    t.integer  "is_smoke"
    t.integer  "is_art_giper"
    t.integer  "is_sahar_diabet"
    t.decimal  "glukoza"
    t.decimal  "oh_before"
    t.decimal  "oh_in_hospital"
    t.decimal  "stenokard"
    t.integer  "is_anevrizm"
    t.integer  "onmk_year"
    t.integer  "pik_year"
    t.string   "xch"
    t.integer  "xch_class"
    t.integer  "sosud_qty"
    t.integer  "is_sosud_75"
    t.integer  "fb_before"
    t.integer  "fb_after"
    t.integer  "lp_before"
    t.integer  "lp_after"
    t.date     "oper_date"
    t.string   "oper_type"
    t.string   "oper_result"
    t.integer  "is_napravlen"
    t.integer  "hospital_id"
    t.string   "fate"
    t.integer  "death_year"
    t.string   "after_invalid"
    t.string   "after_invalid_descr"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "namefull"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "hospital_id"
    t.string   "description"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "role"
  end

end
