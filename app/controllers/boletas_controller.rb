class BoletasController < ApplicationController
  before_action :set_boleta, only: [:show, :edit, :update, :destroy]

  # GET /boletas
  # GET /boletas.json
  def index
    @boletas = Boleta.all
  end

  # GET /boletas/1
  # GET /boletas/1.json
  def show
  end

  # GET /boletas/new
  def new
    @boleta = Boleta.new
  end

  # GET /boletas/1/edit
  def edit
  end

  # POST /boletas
  # POST /boletas.json
  def create
    @boleta = Boleta.new(boleta_params)

    respond_to do |format|
      if @boleta.save
        format.html { redirect_to @boleta, notice: 'Boleta was successfully created.' }
        format.json { render :show, status: :created, location: @boleta }
      else
        format.html { render :new }
        format.json { render json: @boleta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boletas/1
  # PATCH/PUT /boletas/1.json
  def update
    respond_to do |format|
      if @boleta.update(boleta_params)
        format.html { redirect_to @boleta, notice: 'Boleta was successfully updated.' }
        format.json { render :show, status: :ok, location: @boleta }
      else
        format.html { render :edit }
        format.json { render json: @boleta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boletas/1
  # DELETE /boletas/1.json
  def destroy
    @boleta.destroy
    respond_to do |format|
      format.html { redirect_to boletas_url, notice: 'Boleta was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_boleta
      @boleta = Boleta.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def boleta_params
      params.require(:boleta).permit(:persona_id, :numero, :numero_factura, :fecha, :fecha_vencimiento, :estado, :tipo, :condicion, :importe_total, :importe_pendiente, :importe_descontado)
    end
end
