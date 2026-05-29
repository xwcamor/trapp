class FactorManagement::FactorsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:index, :search, :new]
  before_action :set_model_nested, only: [ :show, :edit, :update, :destroy]
  before_action :last_factor, only: [:index, :search ]  

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
      # Ransack search params
      @search_year = params[:search_year]
      @id = params[:id]
      # Ransack search
      @query = Factor.ransack(params[:q])
      # Ransack conditions
      @query.deleted_eq = 0
      @query.transformer_id_eq = @transformer.id
      @query.date_rehearsal_eq =   @search_year if @search_year.to_i > 0
      # Order and pagination
      @results_count =  @query.result(distinct: true)         
      @results =  @query.result(distinct: true).order("date_rehearsal DESC").paginate(:page => params[:page] )
      # Export data
      @export_results =  @query.result(distinct: true)      
      # Final result
      @list_factors = @results

      respond_to do |format|
        format.html
        format.xls { 
          send_data render_to_string(
            :partial=>"factor_management/factors/partials/xls_table"),
            :filename => "Reporte_de_factor_de_potencia_#{Time.now.strftime("%d_%m_%Y")}.xls"
          }      
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
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /factor_management/factors/new
  def new
    if user_permission.include?(66)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /factor_management/factors/1/edit
  def edit
    if user_permission.include?(67)
     else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /factor_management/factors
  # POST /factor_management/factors.json
  def create
    @factor = Factor.new(model_params)
    if @factor.save
      flash[:notice] = 'Se guardaron los datos del Factor de Potencia.'
      flash[:type_message] = 'success'
      redirect_to factor_management_transformer_factors_path(@factor.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Factor de Potencia, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to factor_management_transformer_factors_path(@factor.transformer_id)
    end 
  end

  # PATCH/PUT /factor_management/factors/1
  # PATCH/PUT /factor_management/factors/1.json
  def update
    if @factor.update(model_params)
      flash[:notice] = 'Se guardaron los datos del Factor de Potencia.'
      flash[:type_message] = 'success'
      redirect_to factor_management_transformer_factors_path(@factor.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Factor de Potencia, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to factor_management_transformer_factors_path(@factor.transformer_id)
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
    def set_model
      @transformer = Transformer.find(params[:transformer_id] )
      #@factor = Factor.new
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_model_nested
      @factor = Factor.find(params[:id] )
    end

    # Use callbacks to share common setup or constraints between actions.
    def last_factor
      @last_factor = Factor.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal ASC').last
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:factor).permit!
    end
end