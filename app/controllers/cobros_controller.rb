class CobrosController < ApplicationController
  before_action :set_cobro, only: [:show, :edit, :update, :destroy]

  # GET /cobros
  # GET /cobros.json
  def index
    @cobros = Cobro.all
  end

  # GET /cobros/1
  # GET /cobros/1.json
  def show
  end

  # GET /cobros/new
  def new
    @cobro = Cobro.new
  end

  # GET /cobros/1/edit
  def edit
  end

  # POST /cobros
  # POST /cobros.json
  def create
    @cobro = Cobro.new(cobro_params)

    respond_to do |format|
      if @cobro.save
        format.html { redirect_to @cobro, notice: 'Cobro was successfully created.' }
        format.json { render :show, status: :created, location: @cobro }
      else
        format.html { render :new }
        format.json { render json: @cobro.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cobros/1
  # PATCH/PUT /cobros/1.json
  def update
    respond_to do |format|
      if @cobro.update(cobro_params)
        format.html { redirect_to @cobro, notice: 'Cobro was successfully updated.' }
        format.json { render :show, status: :ok, location: @cobro }
      else
        format.html { render :edit }
        format.json { render json: @cobro.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cobros/1
  # DELETE /cobros/1.json
  def destroy
    @cobro.destroy
    respond_to do |format|
      format.html { redirect_to cobros_url, notice: 'Cobro was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cobro
      @cobro = Cobro.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cobro_params
      params.fetch(:cobro, {})
    end
end
