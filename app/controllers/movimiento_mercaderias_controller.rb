class MovimientoMercaderiasController < ApplicationController
  before_action :set_movimiento_mercaderia, only: [:show, :edit, :update, :destroy]
  before_action :setup_menu, only: [:index, :new, :edit, :show, :create, :update]

  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :stock
    @menu_setup[:side_menu] = :movimientos_mercaderias_sidemenu
  end

  # GET /movimiento_mercaderias
  # GET /movimiento_mercaderias.json
  def index
    get_movimientos
  end

  # GET /movimiento_mercaderias/1
  # GET /movimiento_mercaderias/1.json
  def show
  end

  # GET /movimiento_mercaderias/new
  def new
    @movimiento = MovimientoMercaderia.new
    @movimiento.detalles.build
    render :form
  end

  # GET /movimiento_mercaderias/1/edit
  def edit
    render :form
  end

  # POST /movimiento_mercaderias
  # POST /movimiento_mercaderias.json
  def create
    @movimiento = MovimientoMercaderia.new(movimiento_mercaderia_params)

    respond_to do |format|
      MovimientoMercaderia.transaction do
        if @movimiento.save
          format.html { redirect_to @movimiento, notice: t('mensajes.save_success', recurso: 'el movimiento') }
          format.json { render :show, status: :created, location: @movimiento }
        else
          format.html { render :form }
          format.json { render json: @movimiento.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /movimiento_mercaderias/1
  # PATCH/PUT /movimiento_mercaderias/1.json
  def update
    respond_to do |format|
      if @movimiento.update(movimiento_mercaderia_params)
        format.html { redirect_to @movimiento, notice: t('mensajes.save_success', recurso: 'el movimiento') }
        format.json { render :show, status: :ok, location: @movimiento }
      else
        format.html { render :form }
        format.json { render json: @movimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movimiento_mercaderias/1
  # DELETE /movimiento_mercaderias/1.json
  def destroy
    @movimiento.destroy
    respond_to do |format|
      format.html { redirect_to movimiento_mercaderias_url, notice: t('mensajes.delete_success', recurso: 'el movimiento') }
      format.json { head :no_content }
    end
  end

  def get_movimientos
    @search = MovimientoMercaderia.search(params[:q])
    @movimientos = @search.result.page(params[:page])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movimiento_mercaderia
      @movimiento = MovimientoMercaderia.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movimiento_mercaderia_params
      procesar_cantidades
      params.require(:movimiento_mercaderia).permit(:fecha, :motivo, :tipo,
                                                    detalles_attributes: [:id, :mercaderia_id, :cantidad, :_destroy])
    end

    # reemplazar las comas por puntos en el caso de las cantidades decimales
    def procesar_cantidades
      params[:movimiento_mercaderia][:detalles_attributes].each do |i, d|
        params[:movimiento_mercaderia][:detalles_attributes][i][:cantidad] = cantidad_a_numero(d[:cantidad])
      end
    end
end
