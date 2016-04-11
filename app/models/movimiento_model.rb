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
      periodo.balance = get_balance_periodo_anterior(buscar_por, periodo)
      periodo.save
    end

    # Si el periodo cambió
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
  # Ej.: Si el periodo pasado es Marzo de 2016 retorna el balance de Febrero de 2016
  def self.get_balance_periodo_anterior(buscar_por, periodo)
    buscar_por.delete(:anho)
    buscar_por.delete(:mes)
    periodos = @balances_class.where(buscar_por)
                              .where('anho <= ?', periodo.anho)
                              .order('anho DESC').order('mes DESC')
                              .reject{|p| p.anho == periodo.anho && p.mes > periodo.mes }


    index_del_periodo = periodo.new_record? ? 0 : 1 # si el periodo todavia no existe usar el primero
    periodos.size > index_del_periodo ? periodos[index_del_periodo].balance : 0
  end

  # Elimina movimiento y actualizar balances
  # objeto => es el objeto al que corresponde el movimiento. Ej.: MovimientoMercaderiaDetalle
  # fecha => la fecha a la que correspondia el movimiento
  # cantidad => la cantidad a sumar a los balances
  def self.eliminar_movimiento(objeto, fecha, cantidad)
    init_variables

    movimiento = self.find_or_initialize_by(movimiento_tipo: objeto.class,
                                            objeto.class.to_s.underscore.concat('_id') => objeto.id)

    movimiento.destroy # elimina movimiento

    buscar_por = {}

    self.movimiento_key.each do |k|
      buscar_por[k] = objeto[k]
    end

    # se ajusta los balances
    ajustar_balances(buscar_por, fecha, cantidad)

  end

  # Retorna los movimientos a mostrar en la vista
  # recibe => {elemento_a_buscar(mercaderia, persona, caja, moneda), desde_fecha, hasta_fecha}
  #
  # Ej 1.: MercaderiaExtracto.get_movimientos(mercaderia_id: 31,
  #                                         desde: DateTime.now - 1.month,
  #                                         hasta: DateTime.now)
  #
  # Ej 2.: CajaExtracto.get_movimientos(caja_id: 1, moneda_id: 2,
  #                                     desde: DateTime.now - 1.month,
  #                                     hasta: DateTime.now)
  #
  # Retorna: {balance_anterior: 230, movimientos: movimientos formateados para la vista - VER MovimientosHelper.formatear_movimientos}
  def self.get_movimientos(*args)
    init_variables

    opciones = args.extract_options!

    resultado = {balance_anterior: 0, movimientos: []}

    buscar_por = {}

    self.movimiento_key.each do |k|
      buscar_por[k] = opciones[k]
    end

    # configurar fechas
    desde = opciones[:desde] || DateTime.now.beginning_of_month
    hasta = opciones[:hasta] || DateTime.now.end_of_month

    resultado[:balance_anterior] = get_balance_anterior(buscar_por, desde)

    resultado[:movimientos] = formatear_movimientos(filtrar_movimientos(buscar_por, desde, hasta))

    resultado
  end

  # retorna el balance anterior a una fecha dada
  # Ej.: Si se pasa 15/03/2016 retorna el balance hasta el dia anterior
  def self.get_balance_anterior(buscar_por, desde)
    buscar_por[:anho] = desde.year
    buscar_por[:mes] = desde.month

    periodo_inicial = @balances_class.find_or_initialize_by(buscar_por) # periodo al que corresponde la fecha dada
    balance = get_balance_periodo_anterior(buscar_por, periodo_inicial) # balance del periodo anterior

    # movimientos desde el principio del mes hasta la fecha dada
    movimientos_hasta = formatear_movimientos(filtrar_movimientos(buscar_por, desde.beginning_of_month, (desde.end_of_day - 1.day)))

    # hacer la suma/resta de los movimeintos hasta la fecha dada
    movimientos_hasta.each do |m|
      balance += m[:ingreso]
      balance -= m[:egreso]
    end

    balance

  end

  # filtra los movimientos dependiendo de la instancia y fechas
  def self.filtrar_movimientos(buscar_por, desde, hasta)
    self.where(buscar_por)
        .where('fecha > ? AND fecha < ?', desde, hasta)
        .order(:fecha)
        .includes(self.reflect_on_all_associations.map { |assoc| assoc.name})
  end
end