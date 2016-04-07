class BoletaDetallesController < ApplicationController
  before_action :set_boleta_detalle, only: [:show, :edit, :update, :destroy]

  # GET /boleta_detalles
  # GET /boleta_detalles.json
  def index
    @boleta_detalles = BoletaDetalle.all
  end

  # GET /boleta_detalles/1
  # GET /boleta_detalles/1.json
  def show
  end

  # GET /boleta_detalles/new
  def new
    @boleta_detalle = BoletaDetalle.new
  end

  # GET /boleta_detalles/1/edit
  def edit
  end

  # POST /boleta_detalles
  # POST /boleta_detalles.json
  def create
    @boleta_detalle = BoletaDetalle.new(boleta_detalle_params)

    respond_to do |format|
      if @boleta_detalle.save
        format.html { redirect_to @boleta_detalle, notice: 'Boleta detalle was successfully created.' }
        format.json { render :show, status: :created, location: @boleta_detalle }
      else
        format.html { render :new }
        format.json { render json: @boleta_detalle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boleta_detalles/1
  # PATCH/PUT /boleta_detalles/1.json
  def update
    respond_to do |format|
      if @boleta_detalle.update(boleta_detalle_params)
        format.html { redirect_to @boleta_detalle, notice: 'Boleta detalle was successfully updated.' }
        format.json { render :show, status: :ok, location: @boleta_detalle }
      else
        format.html { render :edit }
        format.json { render json: @boleta_detalle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boleta_detalles/1
  # DELETE /boleta_detalles/1.json
  def destroy
    @boleta_detalle.destroy
    respond_to do |format|
      format.html { redirect_to boleta_detalles_url, notice: 'Boleta detalle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_boleta_detalle
      @boleta_detalle = BoletaDetalle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def boleta_detalle_params
      params.require(:boleta_detalle).permit(:boleta_id, :mercaderia_id, :cantidad, :precio_unitario)
    end
end
