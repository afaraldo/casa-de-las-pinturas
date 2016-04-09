class MovimientoModel < ActiveRecord::Base
  extend MovimientosHelper

  self.abstract_class = true

  # :movimiento_key => Atributos por los que se va a buscar los movimientos
  # Ej. para MercaderiaExtracto debe ser: [:mercaderia_id]
  #     para CajaExtracto debe ser: [:caja_id, :moneda_id]
  #     para CuentaCorrienteExtracto debe ser: [:persona_id]
  #
  # :balances => Nombre de la clase de periodos y balances
  # Ej. para MercaderiaExtracto: 'MercaderiaPeriodoBalance'
  class_attribute :movimiento_key, :balances

  attr_accessor :balances_class

  def self.init_variables
    @balances_class = self.balances.constantize
  end

  def self.crear_o_actualizar_extracto(objeto, fecha, cantidad_anterior, cantidad_nueva)
    init_variables

    buscar_por = {mes: fecha.month, anho: fecha.year}
    diff_fecha = 0
    fecha_anterior = nil

    # Crear o inicializar el movimiento
    movimiento = self.find_or_initialize_by(movimiento_tipo: objeto.class,
                                            objeto.class.to_s.underscore.concat('_id') => objeto.id)

    # Si el movimiento ya existe determinar si cambió de periodo
    unless movimiento.new_record?
      fecha_anterior = movimiento.fecha
      diff_fecha =  (fecha.year * 12 + fecha.month) - (fecha_anterior.year * 12 + fecha_anterior.month)
    end

    # setear los keys del movimiento
    self.movimiento_key.each do |k|
      movimiento[k] = objeto[k]
      buscar_por[k] = objeto[k]
    end

    movimiento.fecha = fecha
    movimiento.save

    # Actualizar balances

    # buscar si ya existe el periodo
    periodo = @balances_class.find_or_initialize_by(buscar_por)

    # si el periodo es nuevo usar el balance del periodo anterior
    if periodo.new_record?
      periodo.balance = get_balance_anterior(buscar_por, periodo)
      periodo.save
    end

    # Si la fecha cambió
    if diff_fecha != 0
      # Restar la cantidad anterior del periodo anterior y los siguientes
      ajustar_balances(buscar_por, fecha_anterior, cantidad_anterior * -1)

      # Sumar la nueva cantidad al periodo nuevo y los siguientes
      ajustar_balances(buscar_por, fecha, cantidad_nueva)
    else
      # Sumar la diferencia de cantidades al periodo y los siguientes
      ajustar_balances(buscar_por, fecha, (cantidad_nueva - cantidad_anterior))
    end

  end

  # Ajusta los balances de los periodos de una fecha dada y los siguientes periodos
  def self.ajustar_balances(buscar_por, fecha, cantidad)
    buscar_por.delete(:mes)
    buscar_por.delete(:anho)
    periodos = @balances_class.where(buscar_por)
                              .where('anho >= ?', fecha.year)
                              .order(:anho).order(:mes)
                              .reject{|p| p.anho == fecha.year && p.mes < fecha.month }

    periodos.each do |p|
      nuevo_balance = p.balance + cantidad
      p.update(balance: nuevo_balance)
    end
  end

  # Retorna el balance anterior al periodo dado
  def self.get_balance_anterior(buscar_por, periodo)
    buscar_por.delete(:anho)
    buscar_por.delete(:mes)
    periodos = @balances_class.where(buscar_por)
                              .where('anho <= ?', periodo.anho)
                              .order('anho DESC').order('mes DESC')

    periodos.size > 0 ? periodos[0].balance : 0
  end

  # eliminar movimiento y actualizar balances
  def self.eliminar_movimiento(objeto, fecha, cantidad)
    init_variables

    movimiento = self.find_or_initialize_by(movimiento_tipo: objeto.class,
                                            objeto.class.to_s.underscore.concat('_id') => objeto.id)

    movimiento.destroy

    buscar_por = {}

    self.movimiento_key.each do |k|
      buscar_por[k] = objeto[k]
    end

    ajustar_balances(buscar_por, fecha, cantidad)

  end

  # TODO
  # Debe retornar el balance anterior a un rango dado y los movimientos del rango
  # y filtrar por tipo
  def self.get_movimientos(*args)

    opciones = args.extract_options!

    buscar_por = {}

    self.movimiento_key.each do |k|
      buscar_por[k] = opciones[k]
    end

    movimientos = self.where(buscar_por)
                      .order(:fecha).includes(self.reflect_on_all_associations.map { |assoc| assoc.name})

    formatear_movimientos(movimientos)

  end
end