class DevanadoManagement::DevanadoTemplateTransformersController < ApplicationController
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
      @devanado_templates = DevanadoTemplate.where("deleted= 0 AND user_id IN (0,?)",current_user.id)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /furano_management/furanos/1/edit
  def edit
    if user_permission.include?(59)
       @devanado_templates = DevanadoTemplate.where("deleted= 0 AND user_id IN (0,?)",current_user.id)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /furano_management/furanos
  # POST /furano_management/furanos.json
  def create
    @devanado_template_transformer = DevanadoTemplateTransformer.new(model_params)
    if @devanado_template_transformer.save
      flash[:notice] = 'Se guardaron los datos del Template.'
      flash[:type_message] = 'success'
      redirect_to devanado_management_transformer_devanados_path(@devanado_template_transformer.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Template, ya hay 1 registro con el mismo nombre.'
      flash[:type_message] = 'danger'
      redirect_to electrical_management_transformer_electricals_path(@devanado_template_transformer.transformer_id)
    end 
  end

  # PATCH/PUT /furano_management/furanos/1
  # PATCH/PUT /furano_management/furanos/1.json
  def update
    if @devanado_template_transformer.update(model_params)
      flash[:notice] = 'Se guardaron los datos del Template.'
      flash[:type_message] = 'success'
      redirect_to devanado_management_transformer_devanados_path(@devanado_template_transformer.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Template, ya hay 1 registro con el mismo nombre.'
      flash[:type_message] = 'danger'
      redirect_to electrical_management_transformer_electricals_path(@devanado_template_transformer.transformer_id)
    end 
  end

  # GET /furano_management/furanos/1/delete
  def delete
    if user_permission.include?(60)
      @devanado_template = DevanadoTemplate.find(params[:devanado_id])
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
    def set_model_transformer
      @transformer = Transformer.find(params[:transformer_id] )
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @devanado_template_transformer = DevanadoTemplateTransformer.find(params[:id] )
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_model_new
      @devanado_template_transformer = DevanadoTemplateTransformer.new
     
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:devanado_template_transformer).permit!
    end
end