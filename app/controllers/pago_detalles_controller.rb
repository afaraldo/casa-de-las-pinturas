class PagoDetallesController < ApplicationController
  before_action :set_pago_detalle, only: [:show, :edit, :update, :destroy]

  # GET /pago_detalles
  # GET /pago_detalles.json
  def index
    @pago_detalles = PagoDetalle.all
  end

  # GET /pago_detalles/1
  # GET /pago_detalles/1.json
  def show
  end

  # GET /pago_detalles/new
  def new
    @pago_detalle = PagoDetalle.new
  end

  # GET /pago_detalles/1/edit
  def edit
  end

  # POST /pago_detalles
  # POST /pago_detalles.json
  def create
    @pago_detalle = PagoDetalle.new(pago_detalle_params)

    respond_to do |format|
      if @pago_detalle.save
        format.html { redirect_to @pago_detalle, notice: 'Pago detalle was successfully created.' }
        format.json { render :show, status: :created, location: @pago_detalle }
      else
        format.html { render :new }
        format.json { render json: @pago_detalle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pago_detalles/1
  # PATCH/PUT /pago_detalles/1.json
  def update
    respond_to do |format|
      if @pago_detalle.update(pago_detalle_params)
        format.html { redirect_to @pago_detalle, notice: 'Pago detalle was successfully updated.' }
        format.json { render :show, status: :ok, location: @pago_detalle }
      else
        format.html { render :edit }
        format.json { render json: @pago_detalle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pago_detalles/1
  # DELETE /pago_detalles/1.json
  def destroy
    @pago_detalle.destroy
    respond_to do |format|
      format.html { redirect_to pago_detalles_url, notice: 'Pago detalle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pago_detalle
      @pago_detalle = PagoDetalle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pago_detalle_params
      params.require(:pago_detalle).permit(:pago_id, :forma, :monto, :moneda_id, :cotizacion)
    end
end
