class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    render 'load_form', format: :js
  end

  # GET /users/1/edit
  def edit
    render 'load_form', format: :js
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      @error = false
      @message = "Se ha guardado el usuario"
      @user = User.all
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de guardar el usuario. #{@user.errors.full_messages.to_sentence}"
    end

    render 'reload_list', format: :js
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update

      if @user.update(user_params)
        @error = false
        @message = "Se ha guardado el usuario"
        @user = User.all
      else
        @error = true
        @message = "Ha ocurrido un problema al tratar de guardar el usuario. #{@user.errors.full_messages.to_sentence}"
      end

      render 'reload_list', format: :js
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy

    if @user.destroy
      @error = false
      @message = "Se ha eliminado el usuario"
      @user = User.all
    else
      @error = true
      @message = "Ha ocurrido un problema al tratar de eliminar el usuario. #{@user.errors.full_messages.to_sentence}"
    end

    render 'reload_list', format: :js
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
