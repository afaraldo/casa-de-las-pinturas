class CreateMercaderiaExtractos < ActiveRecord::Migration
  def change
    create_table :mercaderia_extractos do |t|
      t.belongs_to :mercaderia, index: true
      t.belongs_to :movimiento_mercaderia_detalle, index: true
      t.datetime :fecha
      t.string :movimiento_tipo, limit: 50

      t.timestamps null: false
    end
    add_foreign_key :mercaderia_extractos, :mercaderias
    add_foreign_key :mercaderia_extractos, :movimiento_mercaderia_detalles
  end
end