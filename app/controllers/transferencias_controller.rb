class TransferenciasController < ApplicationController
  def new
  end

  def create
    @movimiento_egreso = CajaMovimiento.new(fecha: Date.today, tipo: :egreso, motivo: "Transferencia de cuenta bancaria a caja registradora", )
  end
end
