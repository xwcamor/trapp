class DevanadoManagement::DevanadoFlowsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model_transformer, only: [:index, :search, :new,:edit, :show]
  before_action :set_model, only: [ :show, :edit, :update, :destroy]
  before_action :set_model_new, only: [:new] 

  # GET/POST /furano_management/furanos/search
  def search
    if user_permission.include?(56)
      index
      render :index
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end     
  end

  # GET /furano_management/furanos
  # GET /furano_management/furanos.json 
  def index
    if user_permission.include?(56)
       
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /furano_management/furanos/1
  # GET /furano_management/furanos/1.json
  def show
    if user_permission.include?(57)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /furano_management/furanos/new
  def new
    if user_permission.include?(58)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /furano_management/furanos/1/edit
  def edit
    if user_permission.include?(59)
     else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /furano_management/furanos
  # POST /furano_management/furanos.json
  def create
    @devanado_flow = DevanadoFlow.new(model_params)
    if @devanado_flow.save
      flash[:notice] = 'Se guardaron los datos del Furano.'
      flash[:type_message] = 'success'
      redirect_to devanado_management_transformer_devanado_flows_path(@devanado_flow.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Furano, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to new_devanado_management_transformer_devanado_path(@devanado_flow.transformer_id)
    end 
  end

  # PATCH/PUT /furano_management/furanos/1
  # PATCH/PUT /furano_management/furanos/1.json
  def update
    if @devanado_flow.update(model_params)
      flash[:notice] = 'Se guardaron los datos del Furano.'
      flash[:type_message] = 'success'
      redirect_to devanado_management_transformer_devanados_path(@devanado_flow.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Furano, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to edit_devanado_management_transformer_devanado_path(@devanado_flow.transformer_id, @devanado_flow)
    end 
  end

  # GET /furano_management/furanos/1/delete
  def delete
    if user_permission.include?(60)
      @devanado_flow = DevanadoFlow.find(params[:devanado_id])
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # DELETE /furano_management/furanos/1
  # DELETE /furano_management/furanos/1.json  
  def destroy
    if user_permission.include?(60)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transformer
      @transformer = Transformer.find(params[:transformer_id] )
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @devanado_flow = DevanadoFlow.find(params[:id] )
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_model_new
      @devanado_flow = DevanadoFlow.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:devanado_flow).permit!
    end
end