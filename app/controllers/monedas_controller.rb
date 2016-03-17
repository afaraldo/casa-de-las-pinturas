class MonedasController < ApplicationController
  before_action :set_moneda, only: [:show, :edit, :update, :destroy]

  # GET /monedas
  # GET /monedas.json
  def index
    @monedas = Moneda.all
  end

  # GET /monedas/1
  # GET /monedas/1.json
  def show
  end

  # GET /monedas/new
  def new
    @moneda = Moneda.new
  end

  # GET /monedas/1/edit
  def edit
  end

  # POST /monedas
  # POST /monedas.json
  def create
    @moneda = Moneda.new(moneda_params)

    respond_to do |format|
      if @moneda.save
        format.html { redirect_to @moneda, notice: 'Moneda was successfully created.' }
        format.json { render :show, status: :created, location: @moneda }
      else
        format.html { render :new }
        format.json { render json: @moneda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /monedas/1
  # PATCH/PUT /monedas/1.json
  def update
    respond_to do |format|
      if @moneda.update(moneda_params)
        format.html { redirect_to @moneda, notice: 'Moneda was successfully updated.' }
        format.json { render :show, status: :ok, location: @moneda }
      else
        format.html { render :edit }
        format.json { render json: @moneda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /monedas/1
  # DELETE /monedas/1.json
  def destroy
    @moneda.destroy
    respond_to do |format|
      format.html { redirect_to monedas_url, notice: 'Moneda was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_moneda
      @moneda = Moneda.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def moneda_params
      params.require(:moneda).permit(:nombre, :abreviatura, :cotizacion, :defecto)
    end
end
