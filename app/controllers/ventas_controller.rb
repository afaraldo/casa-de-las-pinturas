class VentasController < ApplicationController
  layout 'imprimir', only: [:imprimir]

  before_action :set_venta, only: [:show, :edit, :update, :destroy]
  before_action :setup_menu, only: [:index, :new, :edit, :show, :create, :update]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :ventas
    @menu_setup[:side_menu] = :ventas_sidemenu
  end

  def imprimir
    get_ventas
  end

  # GET /ventas
  # GET /ventas.json
  def index
    get_ventas
  end

  # GET /ventas/1
  # GET /ventas/1.json
  def show
    @stock_negativo = @venta.check_detalles_negativos(true)
  end

  # GET /ventas/new
  def new
    @venta = Venta.new
    @venta.detalles.build
    render :form
  end

  # GET /ventas/1/edit
  def edit
    render :form
  end

  # POST /ventas
  # POST /ventas.json
  def create
    #binding.pry
    @venta = Venta.new(venta_params)

    respond_to do |format|
      Venta.transaction do
        if @venta.save
          format.html { redirect_to @venta, notice: t('mensajes.save_success', recurso: 'la venta') }
          format.json { render :show, status: :created, location: @venta }
        else
          format.html { render :form }
          format.json { render json: @venta.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  # PATCH/PUT /ventas/1
  # PATCH/PUT /ventas/1.json
  def update
    @venta.assign_attributes(venta_params)
    @stock_negativo = params[:guardar_si_o_si].present? ? [] : @venta.check_detalles_negativos
    respond_to do |format|
      Venta.transaction do
        if @stock_negativo.size <= 0 && @venta.save
          format.html { redirect_to @venta, notice: t('mensajes.save_success', recurso: 'la venta') }
          format.json { render :show, status: :created, location: @venta }
        else
          format.html { render :form }
          format.json { render json: @venta.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /venta/1
  # DELETE /venta/1.json
  def destroy
    respond_to do |format|
      Venta.transaction do
        if @venta.destroy
          format.html { redirect_to ventas_url, notice: t('mensajes.delete_success', recurso: 'la venta') }
          format.json { head :no_content }
        else
          flash[:error] = t('mensajes.delete_error', recurso: 'la venta', errores: @venta.errors.full_messages.to_sentence)
          format.html { redirect_to @venta }
        end
      end
    end
  end

  private

    def get_ventas
      @search = Venta.search(params[:q])
      @ventas = @search.result.includes(:persona, :detalles).page(params[:page]).per(action_name == 'imprimir' ? LIMITE_REGISTROS_IMPRIMIR : 25)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_venta
      @venta = Venta.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def venta_params
      procesar_cantidades
      params.require(:venta).permit(:persona_id, :numero_comprobante, :fecha, :fecha_vencimiento, :estado, :condicion,
                                     detalles_attributes: [:id, :mercaderia_id, :cantidad, :precio_unitario, :_destroy])
    end

    def procesar_cantidades
      params[:venta][:detalles_attributes].each do |i, d|
        params[:venta][:detalles_attributes][i][:cantidad] = cantidad_a_numero(d[:cantidad])
        params[:venta][:detalles_attributes][i][:precio_unitario] = cantidad_a_numero(d[:precio_unitario])
      end
    end

end
