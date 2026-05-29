class OilTypeManagement::OilTypesController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy]

  # GET /oil_type_management/oil_types
  # GET /oil_type_management/oil_types.json 
  def index
    if user_permission.include?(125)
      @oil_types = OilType.where(deleted: 0)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /oil_type_management/oil_types/new
  def new
    if user_permission.include?(126)
      @oil_type = OilType.new
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /oil_type_management/oil_types/1
  # GET /oil_type_management/oil_types/1.json
  def show
    if user_permission.include?(127)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end
  


  # GET /oil_type_management/oil_types/1/edit
  def edit
    if user_permission.include?(128)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /oil_type_management/oil_types
  # POST /oil_type_management/oil_types.json
  def create
    @oil_type = OilType.new(model_params)
    if @oil_type.save
      flash[:notice] = 'Data creada.'
      flash[:type_message] = 'success'
      redirect_to [:oil_type_management,:oil_types]
    else
      flash[:notice] = 'Error al crear.'
      flash[:type_message] = 'danger'
      render :new
    end 
  end

  # PATCH/PUT /oil_type_management/oil_types/1
  # PATCH/PUT /oil_type_management/oil_types/1.json
  def update
    if @oil_type.update(model_params)
      flash[:notice] = 'Data actualizada.'
      flash[:type_message] = 'success'
      redirect_to [:oil_type_management, @oil_type]    
    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      render :edit
    end
  end

  # DELETE /oil_type_management/oil_types/1
  # DELETE /oil_type_management/oil_types/1.json  
  def destroy
    if user_permission.include?(129)
      @oil_type.update_attribute(:deleted,1)
      flash[:notice] = 'Data eliminada'
      flash[:type_message] = 'success'
      redirect_to [:oil_type_management,:oil_types]
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @oil_type = OilType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:oil_type).permit!
    end
end
