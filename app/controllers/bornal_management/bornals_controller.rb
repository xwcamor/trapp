class BornalManagement::BornalsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model,      only: [:index, :search, :new]
  before_action :set_model_nested, only: [ :show, :edit, :update, :destroy]

  # GET/POST /factor_management/factors/search
  def search
    if user_permission.include?(24)
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
    if user_permission.include?(24)

      # Ransack search params
      @search_year = params[:search_year]
      @id = params[:id]
      # Ransack search
      @query = Bornal.ransack(params[:q])
      # Ransack conditions
      @query.deleted_eq = 0
      @query.transformer_id_eq = @transformer.id
      @query.date_rehearsal_eq =   @search_year if @search_year.to_i > 0
      # Order and pagination
      @results =  @query.result(distinct: true).order("date_rehearsal DESC").paginate(:page => params[:page] )
      # Final result
      @list_bornals = @results
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /factor_management/factors/1
  # GET /factor_management/factors/1.json
  def show
    if user_permission.include?(25)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /factor_management/factors/new
  def new
    if user_permission.include?(26)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /factor_management/factors/1/edit
  def edit
    if user_permission.include?(27)
     else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /factor_management/factors
  # POST /factor_management/factors.json
  def create
    @bornal = Bornal.new(model_params)
    if @bornal.save
      flash[:notice] = 'Data creada.'
      flash[:type_message] = 'success'
      redirect_to :controller=>"bornal_management/bornals",:action=>"index",:id=>@bornal.transformer_id
    else
      flash[:notice] = 'Error al crear.'
      flash[:type_message] = 'danger'
      render :new
    end 
  end

  # PATCH/PUT /factor_management/factors/1
  # PATCH/PUT /factor_management/factors/1.json
  def update
    if @bornal.update(model_params)
      flash[:notice] = 'Data actualizada.'
      flash[:type_message] = 'success'
      redirect_to :controller=>"bornal_management/bornals",:action=>"index",:id=>@bornal.transformer_id
    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      render :edit
    end
  end

  # DELETE /factor_management/factors/1
  # DELETE /factor_management/factors/1.json  
  def destroy
    if user_permission.include?(28)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @transformer = Transformer.find(params[:id] )
      @bornal = Bornal.new
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_model_nested
      @bornal = Bornal.find(params[:id] )
    end
       
    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:bornal).permit!
    end
end