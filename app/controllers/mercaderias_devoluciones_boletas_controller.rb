class MercaderiasDevolucionesBoletasController < ApplicationController
  layout 'imprimir', only: [:imprimir]

  before_action :set_mercaderias_devoluciones_boleta, only: [:show, :edit, :update, :destroy]
  before_action :setup_menu, only: [:index]


  # configuracion del menu
  def setup_menu
    @menu_setup[:main_menu] = :compras
    @menu_setup[:side_menu] = :devoluciones_sidemenu
  end

  # GET /mercaderias_devoluciones_boletas/1
  # GET /mercaderias_devoluciones_boletas/1.json
  def show
  end

  # GET /mercaderias_devoluciones_boletas
  # GET /mercaderias_devoluciones_boletas.json
  def index
    get_devoluciones
  end

  def imprimir
    get_devoluciones
  end

  # GET /mercaderias_devoluciones_boletas/new
  def new
    @mercaderias_devoluciones_boleta = MercaderiasDevolucionesBoleta.new
  end

  # GET /mercaderias_devoluciones_boletas/1/edit
  def edit
  end

  # POST /mercaderias_devoluciones_boletas
  # POST /mercaderias_devoluciones_boletas.json
  def create
    @mercaderias_devoluciones_boleta = MercaderiasDevolucionesBoleta.new(mercaderias_devoluciones_boleta_params)

    respond_to do |format|
      if @mercaderias_devoluciones_boleta.save
        format.html { redirect_to @mercaderias_devoluciones_boleta, notice: 'Mercaderias devoluciones boleta was successfully created.' }
        format.json { render :show, status: :created, location: @mercaderias_devoluciones_boleta }
      else
        format.html { render :new }
        format.json { render json: @mercaderias_devoluciones_boleta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mercaderias_devoluciones_boletas/1
  # PATCH/PUT /mercaderias_devoluciones_boletas/1.json
  def update
    respond_to do |format|
      if @mercaderias_devoluciones_boleta.update(mercaderias_devoluciones_boleta_params)
        format.html { redirect_to @mercaderias_devoluciones_boleta, notice: 'Mercaderias devoluciones boleta was successfully updated.' }
        format.json { render :show, status: :ok, location: @mercaderias_devoluciones_boleta }
      else
        format.html { render :edit }
        format.json { render json: @mercaderias_devoluciones_boleta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mercaderias_devoluciones_boletas/1
  # DELETE /mercaderias_devoluciones_boletas/1.json
  def destroy
    @mercaderias_devoluciones_boleta.destroy
    respond_to do |format|
      format.html { redirect_to mercaderias_devoluciones_boletas_url, notice: 'Mercaderias devoluciones boleta was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mercaderias_devoluciones_boleta
      @mercaderias_devoluciones_boleta = MercaderiasDevolucionesBoleta.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mercaderias_devoluciones_boleta_params
      params.require(:mercaderias_devoluciones_boleta).permit(:boleta_id)
    end

    def get_devoluciones
      procesar_fechas
      @search = MercaderiasDevolucionesBoleta.search(params[:q])
      @mercaderias_devoluciones_boletas = @search.result.includes(:persona).page(params[:page]).per(action_name == 'imprimir' ? LIMITE_REGISTROS_IMPRIMIR : 25)
    end
    def procesar_fechas
      if params[:q].present? && params[:q][:fecha_lt].present?
        params[:q][:fecha_lt] = params[:q][:fecha_lt].to_datetime.end_of_day
      end
    end
end
