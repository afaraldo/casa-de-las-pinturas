class CreateNotasCreditosDebitos < ActiveRecord::Migration
  def change
    create_table :notas_creditos_debitos do |t|
      t.references :persona, index: true
      t.datetime :fecha, null: false
      t.string :motivo, null: false
      t.integer :numero, null: false
      t.decimal :importe_total, precision: 15, scale: 2, null: false
      t.decimal :credito_restante, precision: 15, scale: 2, null: false
      t.string :tipo, limit: 20, null: false

      t.datetime :deleted_at, null: true
      t.timestamps null: false
    end
    add_foreign_key :notas_creditos_debitos, :personas
  end
end
