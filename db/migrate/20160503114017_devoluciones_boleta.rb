class DevolucionesBoleta < ActiveRecord::Migration
  def change
    create_table :devoluciones_boleta do |t|
      t.belongs_to :notas_creditos_debito, index: true
      t.belongs_to :boleta, index: true

      t.timestamps null: false
    end

    add_foreign_key :devoluciones_boleta, :notas_creditos_debitos
    add_foreign_key :devoluciones_boleta, :boletas
  end
end
