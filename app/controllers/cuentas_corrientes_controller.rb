class CuentasCorrientesController < ApplicationController

  layout 'imprimir', only: [:imprimir_extracto]

  before_action :setup_menu, only: [:clientes, :proveedores]
  before_action :set_persona
  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = action_name == 'proveedores' ? :compras : :ventas
    @menu_setup[:side_menu] = action_name == 'proveedores' ? :cuentas_corrientes_proveedores : :cuentas_corrientes_clientes
  end

  def imprimir_extracto
    get_movimientos
  end

  def clientes
    get_movimientos
    render :listado
  end

  def proveedores
    get_movimientos
    render :listado
  end

  def set_persona
    @persona = Persona.find_by(id: params[:persona_id])
  end

  def get_movimientos
    @movimientos = nil

    # Configurando las fechas
    @desde = nil
    @hasta = nil

    if params[:fecha_desde].present? && params[:fecha_hasta].present?
      @desde = params[:fecha_desde].to_datetime
      @hasta = params[:fecha_hasta].to_datetime
    end

    # buscar movimientos
    if params[:persona_id].present?
      @movimientos = CuentaCorrienteExtracto.get_movimientos(persona_id: params[:persona_id],
                                                             desde: @desde,
                                                             hasta: @hasta,
                                                             page: params[:page],
                                                             limit: action_name == 'imprimir_extracto' ? LIMITE_REGISTROS_IMPRIMIR : nil)
    end
  end

end
