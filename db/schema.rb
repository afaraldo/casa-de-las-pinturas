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

ActiveRecord::Schema.define(version: 20160508014124) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boleta_detalles", force: :cascade do |t|
    t.integer  "boleta_id"
    t.integer  "mercaderia_id"
    t.decimal  "cantidad",        precision: 15, scale: 3, null: false
    t.decimal  "precio_unitario", precision: 15, scale: 2, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "boleta_detalles", ["boleta_id"], name: "index_boleta_detalles_on_boleta_id", using: :btree
  add_index "boleta_detalles", ["mercaderia_id"], name: "index_boleta_detalles_on_mercaderia_id", using: :btree

  create_table "boletas", force: :cascade do |t|
    t.integer  "persona_id"
    t.string   "numero_comprobante"
    t.datetime "fecha",                                                                null: false
    t.datetime "fecha_vencimiento"
    t.string   "estado",             limit: 20,                                        null: false
    t.string   "tipo",               limit: 20,                                        null: false
    t.string   "condicion",          limit: 20,                                        null: false
    t.decimal  "importe_total",                 precision: 15, scale: 2,               null: false
    t.decimal  "importe_pendiente",             precision: 15, scale: 2,               null: false
    t.decimal  "importe_descontado",            precision: 15, scale: 2, default: 0.0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
  end

  add_index "boletas", ["persona_id"], name: "index_boletas_on_persona_id", using: :btree

  create_table "caja_extractos", force: :cascade do |t|
    t.integer  "caja_id"
    t.integer  "moneda_id"
    t.integer  "caja_movimiento_detalle_id"
    t.datetime "fecha",                                 null: false
    t.string   "movimiento_tipo",            limit: 50, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "recibo_detalle_id"
  end

  add_index "caja_extractos", ["caja_id"], name: "index_caja_extractos_on_caja_id", using: :btree
  add_index "caja_extractos", ["caja_movimiento_detalle_id"], name: "index_caja_extractos_on_caja_movimiento_detalle_id", using: :btree
  add_index "caja_extractos", ["moneda_id"], name: "index_caja_extractos_on_moneda_id", using: :btree
  add_index "caja_extractos", ["recibo_detalle_id"], name: "index_caja_extractos_on_recibo_detalle_id", using: :btree

  create_table "caja_movimiento_detalles", force: :cascade do |t|
    t.integer  "caja_movimiento_id"
    t.integer  "moneda_id"
    t.decimal  "monto",                         precision: 15, scale: 2, default: 0.0, null: false
    t.string   "forma",              limit: 20,                                        null: false
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.datetime "deleted_at"
    t.decimal  "cotizacion",                    precision: 15, scale: 2
  end

  add_index "caja_movimiento_detalles", ["caja_movimiento_id"], name: "index_caja_movimiento_detalles_on_caja_movimiento_id", using: :btree
  add_index "caja_movimiento_detalles", ["moneda_id"], name: "index_caja_movimiento_detalles_on_moneda_id", using: :btree

  create_table "caja_movimientos", force: :cascade do |t|
    t.integer  "categoria_gasto_id"
    t.datetime "fecha",                                                                 null: false
    t.string   "motivo",             limit: 255,                                        null: false
    t.string   "tipo",               limit: 20,                                         null: false
    t.decimal  "importe_total",                  precision: 15, scale: 2, default: 0.0, null: false
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.datetime "deleted_at"
    t.integer  "caja_id"
  end

  add_index "caja_movimientos", ["caja_id"], name: "index_caja_movimientos_on_caja_id", using: :btree
  add_index "caja_movimientos", ["categoria_gasto_id"], name: "index_caja_movimientos_on_categoria_gasto_id", using: :btree

  create_table "caja_periodo_balances", force: :cascade do |t|
    t.integer  "caja_id"
    t.integer  "moneda_id"
    t.integer  "mes"
    t.integer  "anho"
    t.decimal  "balance",    precision: 15, scale: 3
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "caja_periodo_balances", ["caja_id"], name: "index_caja_periodo_balances_on_caja_id", using: :btree
  add_index "caja_periodo_balances", ["moneda_id"], name: "index_caja_periodo_balances_on_moneda_id", using: :btree

  create_table "cajas", force: :cascade do |t|
    t.string   "nombre",     limit: 50, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "categoria_gastos", force: :cascade do |t|
    t.string   "nombre",     limit: 50, null: false
    t.datetime "deleted_at"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "categorias", force: :cascade do |t|
    t.string   "nombre",             limit: 50, null: false
    t.integer  "categoria_padre_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "configuraciones", force: :cascade do |t|
    t.string   "empresa_nombre"
    t.string   "empresa_direccion"
    t.string   "empresa_telefono"
    t.string   "empresa_email"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "avatar"
  end

  create_table "cuenta_corriente_periodo_balances", force: :cascade do |t|
    t.integer  "persona_id"
    t.integer  "mes",                                 null: false
    t.integer  "anho",                                null: false
    t.decimal  "balance",    precision: 15, scale: 2, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "cuenta_corriente_periodo_balances", ["persona_id"], name: "index_cuenta_corriente_periodo_balances_on_persona_id", using: :btree

  create_table "cuentas_corrientes_extractos", force: :cascade do |t|
    t.integer  "persona_id"
    t.datetime "fecha",                      null: false
    t.string   "movimiento_tipo", limit: 50
    t.integer  "boleta_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "recibo_id"
  end

  add_index "cuentas_corrientes_extractos", ["boleta_id"], name: "index_cuentas_corrientes_extractos_on_boleta_id", using: :btree
  add_index "cuentas_corrientes_extractos", ["persona_id"], name: "index_cuentas_corrientes_extractos_on_persona_id", using: :btree
  add_index "cuentas_corrientes_extractos", ["recibo_id"], name: "index_cuentas_corrientes_extractos_on_recibo_id", using: :btree

  create_table "mercaderia_extractos", force: :cascade do |t|
    t.integer  "mercaderia_id"
    t.integer  "movimiento_mercaderia_detalle_id"
    t.datetime "fecha"
    t.string   "movimiento_tipo",                  limit: 50
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "boleta_detalle_id"
  end

  add_index "mercaderia_extractos", ["mercaderia_id"], name: "index_mercaderia_extractos_on_mercaderia_id", using: :btree
  add_index "mercaderia_extractos", ["movimiento_mercaderia_detalle_id"], name: "index_mercaderia_extractos_on_movimiento_mercaderia_detalle_id", using: :btree

  create_table "mercaderia_periodo_balances", force: :cascade do |t|
    t.integer  "mercaderia_id"
    t.integer  "mes"
    t.integer  "anho"
    t.decimal  "balance",       precision: 15, scale: 3
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "mercaderia_periodo_balances", ["mercaderia_id"], name: "index_mercaderia_periodo_balances_on_mercaderia_id", using: :btree

  create_table "mercaderias", force: :cascade do |t|
    t.string   "codigo",               limit: 20
    t.string   "nombre",               limit: 50
    t.string   "descripcion",          limit: 150
    t.string   "unidad_de_medida",     limit: 10,                                         null: false
    t.decimal  "precio_venta_contado",             precision: 15, scale: 2, default: 0.0, null: false
    t.decimal  "precio_venta_credito",             precision: 15, scale: 2, default: 0.0, null: false
    t.decimal  "costo",                            precision: 15, scale: 2, default: 0.0, null: false
    t.integer  "categoria_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.decimal  "stock_inicial",                    precision: 15, scale: 3, default: 0.0, null: false
    t.decimal  "stock_minimo",                     precision: 15, scale: 2, default: 0.0, null: false
  end

  add_index "mercaderias", ["categoria_id"], name: "index_mercaderias_on_categoria_id", using: :btree
  add_index "mercaderias", ["codigo"], name: "index_mercaderias_on_codigo", using: :btree
  add_index "mercaderias", ["nombre"], name: "index_mercaderias_on_nombre", using: :btree

  create_table "monedas", force: :cascade do |t|
    t.string   "nombre"
    t.string   "abreviatura"
    t.decimal  "cotizacion",  precision: 15, scale: 2, default: 0.0,   null: false
    t.boolean  "defecto",                              default: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.datetime "deleted_at"
  end

  add_index "monedas", ["deleted_at"], name: "index_monedas_on_deleted_at", using: :btree

  create_table "movimiento_mercaderia_detalles", force: :cascade do |t|
    t.integer  "movimiento_mercaderia_id"
    t.integer  "mercaderia_id"
    t.decimal  "cantidad",                 precision: 15, scale: 3
    t.datetime "deleted_at"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "movimiento_mercaderia_detalles", ["mercaderia_id"], name: "index_movimiento_mercaderia_detalles_on_mercaderia_id", using: :btree
  add_index "movimiento_mercaderia_detalles", ["movimiento_mercaderia_id"], name: "index_mov_mercaderia_det_on_movimiento_mercaderia_id", using: :btree

  create_table "movimiento_mercaderias", force: :cascade do |t|
    t.datetime "fecha"
    t.string   "motivo",     limit: 255
    t.string   "tipo",       limit: 15
    t.datetime "deleted_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "personas", force: :cascade do |t|
    t.string   "nombre",           limit: 150
    t.string   "telefono",         limit: 50
    t.string   "direccion",        limit: 200
    t.string   "numero_documento", limit: 20
    t.string   "tipo",             limit: 15,  null: false
    t.decimal  "limite_credito"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "deleted_at"
  end

  add_index "personas", ["deleted_at"], name: "index_personas_on_deleted_at", using: :btree

  create_table "recibo_detalles", force: :cascade do |t|
    t.integer  "recibo_id"
    t.string   "forma",      limit: 10
    t.decimal  "monto",                 precision: 15, scale: 2
    t.decimal  "cotizacion",            precision: 15, scale: 2
    t.integer  "moneda_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.datetime "deleted_at"
    t.integer  "caja_id"
  end

  add_index "recibo_detalles", ["caja_id"], name: "index_recibo_detalles_on_caja_id", using: :btree
  add_index "recibo_detalles", ["moneda_id"], name: "index_recibo_detalles_on_moneda_id", using: :btree
  add_index "recibo_detalles", ["recibo_id"], name: "index_recibo_detalles_on_recibo_id", using: :btree

  create_table "recibos", force: :cascade do |t|
    t.datetime "fecha"
    t.decimal  "total_efectivo",                     precision: 15, scale: 2
    t.decimal  "total_tarjeta",                      precision: 15, scale: 2
    t.decimal  "total_credito_utilizado",            precision: 15, scale: 2
    t.string   "tipo",                    limit: 10
    t.datetime "deleted_at"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.integer  "persona_id"
    t.string   "numero_comprobante",      limit: 50
    t.string   "condicion",               limit: 20,                          null: false
  end

  add_index "recibos", ["persona_id"], name: "index_recibos_on_persona_id", using: :btree

  create_table "recibos_boletas", force: :cascade do |t|
    t.integer  "recibo_id"
    t.integer  "boleta_id"
    t.decimal  "monto_utilizado", precision: 15, scale: 2
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.datetime "deleted_at"
  end

  add_index "recibos_boletas", ["boleta_id"], name: "index_recibos_boletas_on_boleta_id", using: :btree
  add_index "recibos_boletas", ["recibo_id"], name: "index_recibos_boletas_on_recibo_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 20,              null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",                   default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "persona_id"
    t.string   "rol",                    limit: 20,              null: false
    t.date     "deleted_at"
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["persona_id"], name: "index_users_on_persona_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "boleta_detalles", "boletas"
  add_foreign_key "boleta_detalles", "mercaderias"
  add_foreign_key "boletas", "personas"
  add_foreign_key "caja_extractos", "caja_movimiento_detalles"
  add_foreign_key "caja_extractos", "cajas"
  add_foreign_key "caja_extractos", "monedas"
  add_foreign_key "caja_extractos", "recibo_detalles"
  add_foreign_key "caja_movimiento_detalles", "caja_movimientos"
  add_foreign_key "caja_movimiento_detalles", "monedas"
  add_foreign_key "caja_movimientos", "cajas"
  add_foreign_key "caja_movimientos", "categoria_gastos"
  add_foreign_key "caja_periodo_balances", "cajas"
  add_foreign_key "caja_periodo_balances", "monedas"
  add_foreign_key "cuenta_corriente_periodo_balances", "personas"
  add_foreign_key "cuentas_corrientes_extractos", "boletas"
  add_foreign_key "cuentas_corrientes_extractos", "personas"
  add_foreign_key "cuentas_corrientes_extractos", "recibos"
  add_foreign_key "mercaderia_extractos", "boleta_detalles"
  add_foreign_key "mercaderia_extractos", "mercaderias"
  add_foreign_key "mercaderia_extractos", "movimiento_mercaderia_detalles"
  add_foreign_key "mercaderia_periodo_balances", "mercaderias"
  add_foreign_key "mercaderias", "categorias"
  add_foreign_key "movimiento_mercaderia_detalles", "mercaderias"
  add_foreign_key "movimiento_mercaderia_detalles", "movimiento_mercaderias"
  add_foreign_key "recibo_detalles", "cajas"
  add_foreign_key "recibo_detalles", "monedas"
  add_foreign_key "recibo_detalles", "recibos"
  add_foreign_key "recibos", "personas"
  add_foreign_key "recibos_boletas", "boletas"
  add_foreign_key "recibos_boletas", "recibos"
  add_foreign_key "users", "personas"
end
