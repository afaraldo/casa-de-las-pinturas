class CajaPeriodoBalance < ActiveRecord::Base
  belongs_to :caja
  belongs_to :moneda

  scope :saldo_por_moneda, lambda { |caja, moneda| where(caja_id: caja, moneda_id: moneda).order('anho DESC').order('mes DESC').limit(1) }
end
