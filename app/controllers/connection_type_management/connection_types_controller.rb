class ConnectionTypeManagement::ConnectionTypesController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy]

  # GET /connection_type_management/connection_types
  # GET /connection_type_management/connection_types.json 
  def index
    if user_permission.include?(78)
      @connection_types = ConnectionType.where(deleted: 0)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /connection_type_management/connection_types/1
  # GET /connection_type_management/connection_types/1.json
  def show
    if user_permission.include?(80)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end
  
  # GET /connection_type_management/connection_types/new
  def new
    if user_permission.include?(79)
      @connection_type = ConnectionType.new
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /connection_type_management/connection_types/1/edit
  def edit
    if user_permission.include?(81)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /connection_type_management/connection_types
  # POST /connection_type_management/connection_types.json
  def create
    @connection_type = ConnectionType.new(model_params)
    if @connection_type.save
      flash[:notice] = 'Data creada.'
      flash[:type_message] = 'success'
      redirect_to [:connection_type_management,:connection_types]
    else
      flash[:notice] = 'Error al crear.'
      flash[:type_message] = 'danger'
      render :new
    end 
  end

  # PATCH/PUT /connection_type_management/connection_types/1
  # PATCH/PUT /connection_type_management/connection_types/1.json
  def update
    if @connection_type.update(model_params)
      flash[:notice] = 'Data actualizada.'
      flash[:type_message] = 'success'
      redirect_to [:connection_type_management, @connection_type]    
    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      render :edit
    end
  end

  # DELETE /connection_type_management/connection_types/1
  # DELETE /connection_type_management/connection_types/1.json  
  def destroy
    if user_permission.include?(82)
      @connection_type.update_attribute(:deleted,1)
      flash[:notice] = 'Data eliminada'
      flash[:type_message] = 'success'
      redirect_to [:connection_type_management,:connection_types]
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @connection_type = ConnectionType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:connection_type).permit!
    end
end
