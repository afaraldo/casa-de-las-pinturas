class CreateNotasCreditosDebitos < ActiveRecord::Migration
  def change
    create_table :notas_creditos_debitos do |t|
      t.references :persona, index: true
      t.datetime :fecha, null: false
      t.string :motivo, null: false
      t.integer :numero
      t.decimal :importe_total, precision: 15, scale: 2
      t.decimal :credito_restante, precision: 15, scale: 2
      t.string :tipo, limit: 20

      t.datetime :deleted_at, null: true
      t.timestamps null: false
    end
    add_foreign_key :notas_creditos_debitos, :personas
  end
end
