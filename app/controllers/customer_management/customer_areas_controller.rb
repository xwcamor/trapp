class CustomerManagement::CustomerAreasController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy ]
  before_action :set_customer, only: [:index, :search, :new , :edit, :delete, :detroy]
  before_action :set_model_new, only: [:new]
  before_action :set_select_new, only: [:new, :create]
  before_action :set_select_edit, only: [:edit, :update]

  # GET/POST /customer_management/customer_areas/search
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

  # GET /customer_management/customer_areas
  # GET /customer_management/customer_areas.json 
  def index
    if user_permission.include?(24)
      @list_customer_areas = CustomerArea.where("deleted = 0 AND customer_id = ?",params[:customer_id]).includes(:customer_location).order("name ASC")   
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end
  
  # GET /customer_management/customer_areas/new
  def new
    if user_permission.include?(26)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /customer_management/customer_areas/1/edit
  def edit
    if user_permission.include?(24)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /customer_management/customer_areas
  # POST /customer_management/customer_areas.json
  def create
    @customer_area = CustomerArea.new(model_params)
    if @customer_area.save
      flash[:notice] = 'Se guardó correctamente el área.'
      flash[:type_message] = 'success' 
      redirect_to customer_management_customer_customer_areas_path(@customer_area.customer_id )
    else
      flash[:notice] = 'No se puede guardar porque el área ya existe.'
      flash[:type_message] = 'danger'
      redirect_to new_customer_management_customer_customer_area_path(@customer_area.customer_id )
    end 
  end

  # PATCH/PUT /customer_management/customer_areas/1
  # PATCH/PUT /customer_management/customer_areas/1.json
  def update
    if @customer_area.update(model_params)
      flash[:notice] = 'Se actualizó correctamente el área.'
      flash[:type_message] = 'success'
      redirect_to customer_management_customer_customer_areas_path(@customer_area.customer_id )
    else
      flash[:notice] = 'No se puede guardar porque el área ya existe.'
      flash[:type_message] = 'danger'
      redirect_to edit_customer_management_customer_customer_area_path(@customer_area.customer_id,@customer_area.id )
    end
  end

  # GET /customer_management/customer_areas/1/delete
  def delete
    if user_permission.include?(24)
      @customer_area = CustomerArea.find(params[:customer_area_id])
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # DELETE /customer_management/customer_areas/1
  # DELETE /customer_management/customer_areas/1.json  
  def destroy
    if user_permission.include?(24)
      @customer_area.update_attribute(:deleted,1)
      flash[:notice] = 'Se ha eliminado la ubicación.'
      flash[:type_message] = 'danger'    
      redirect_to customer_management_customer_customer_areas_path(@customer_area.customer_id )      
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @customer_area = CustomerArea.find(params[:id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_model_new
      @customer_area = CustomerArea.new
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:customer_id] )
      @list_customer_areas =CustomerArea.where('deleted= 0 AND customer_id = ?',@customer.id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_select_new
      @customer_locations = CustomerLocation.where("deleted= 0 AND customer_id = ?", params[:customer_id] ).order("name ASC")
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_select_edit
       @customer_locations = CustomerLocation.where("deleted= 0 AND customer_id = ?", params[:customer_id] ).order("name ASC")
    end    

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:customer_area).permit!
    end
end