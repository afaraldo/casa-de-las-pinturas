class CreateCuentasCorrientesExtractos < ActiveRecord::Migration
  def change
    create_table :cuentas_corrientes_extractos do |t|
      t.references :persona, index: true
      t.datetime :fecha, null: false
      t.string :movimiento_tipo, limit: 50
      t.references :boleta, index: true

      t.timestamps null: false
    end
    add_foreign_key :cuentas_corrientes_extractos, :personas
    add_foreign_key :cuentas_corrientes_extractos, :boletas
  end
end
