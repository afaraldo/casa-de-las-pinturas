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

ActiveRecord::Schema.define(version: 20160311002600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "configucaions", force: :cascade do |t|
    t.string   "empresa_nombre"
    t.string   "logo"
    t.string   "empresa_direccion"
    t.string   "empresa_telefono"
    t.string   "empresa_email"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "configuraciones", force: :cascade do |t|
    t.string   "empresa_nombre"
    t.string   "logo"
    t.string   "empresa_direccion"
    t.string   "empresa_telefono"
    t.string   "empresa_email"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "personas", force: :cascade do |t|
    t.string   "nombre"
    t.string   "telefono"
    t.string   "direccion"
    t.string   "ruc"
    t.string   "type",           null: false
    t.decimal  "limite_credito"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
