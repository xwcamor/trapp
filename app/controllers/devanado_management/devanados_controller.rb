class DevanadoManagement::DevanadosController < ApplicationController
  before_action :authenticate_user
  before_action :set_model_transformer, only: [:index, :search, :new,:edit, :show,:delete]
  before_action :set_model, only: [ :show, :edit, :update, :destroy ]
  before_action :set_model_new, only: [:new] 

  # GET/POST /factor_management/factors/search
  def search
    if user_permission.include?(64)
      index
      render :index
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end     
  end

  # GET /factor_management/factors
  # GET /factor_management/factors.json 
  def index
    if user_permission.include?(64)
      @devanado_template_transformer = DevanadoTemplateTransformer.find_by_transformer_id(@transformer.id)
      # Ransack search
      @query = Devanado.ransack(params[:q])
      # Ransack conditions
      @query.deleted_eq = 0
      @query.transformer_id_eq = @transformer.id
   
      # Order and pagination
      @results_count =  @query.result(distinct: true)         
      @results =  @query.result(distinct: true).order("date_rehearsal DESC").paginate(:page => params[:page] )
   
      # Final result
      @list_devanados = @results
  
      if @list_devanados.size > 0
        @calculation = DevanadoDetail.find_by_sql("SELECT * FROM view_devanado_details_by_transformer_id_#{@transformer.id} " )
      end
      
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /factor_management/factors/1
  # GET /factor_management/factors/1.json
  def show
    if user_permission.include?(65)
      @devanado_template_transformer = DevanadoTemplateTransformer.find_by_transformer_id(@transformer.id)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /factor_management/factors/new
  def new
    if user_permission.include?(66)
      @devanado_template_transformer = DevanadoTemplateTransformer.find_by_transformer_id(@transformer.id)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /factor_management/factors/1/edit
  def edit
    if user_permission.include?(67)
      @devanado_template_transformer = DevanadoTemplateTransformer.find_by_transformer_id(@transformer.id)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /factor_management/factors
  # POST /factor_management/factors.json
  def create
    @devanado = Devanado.new(model_params)
    if @devanado.save
      flash[:notice] = 'Se guardaron los datos de la Resistencia de Devanado.'
      flash[:type_message] = 'success'
      redirect_to devanado_management_transformer_devanados_path(@devanado.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos de Resistencia de Devanado, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to devanado_management_transformer_devanados_path(@devanado.transformer_id)
    end 
  end

  # PATCH/PUT /factor_management/factors/1
  # PATCH/PUT /factor_management/factors/1.json
  def update
    if @devanado.update(model_params)
#      @devanado_details = DevanadoDetail.where("devanado_id =?",@devanado.id).destroy_all
      flash[:notice] = 'Se guardaron los datos de la Resistencia de Devanado.'
      flash[:type_message] = 'success'
      redirect_to devanado_management_transformer_devanados_path(@devanado.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos de Resistencia de Devanado, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to edit_devanado_management_transformer_devanado_path(@devanado.transformer_id)
    end 
  end

  # GET /chromatographical_management/customers/1/delete
  def delete
    if user_permission.include?(68)
      @devanado_template_transformer = DevanadoTemplateTransformer.find_by_transformer_id(@transformer.id)
      @devanado = Devanado.find(params[:devanado_id])
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # DELETE /factor_management/factors/1
  # DELETE /factor_management/factors/1.json  
  def destroy
    if user_permission.include?(68)
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
      @devanado = Devanado.find(params[:id] )
    end
 
    # Use callbacks to share common setup or constraints between actions.
    def set_model_new
      @devanado = Devanado.new
      1.times do
        @nested_contact = @devanado.devanado_details.build
      end      
    end 

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:devanado).permit!
    end
end