class CustomerManagement::CustomerLocationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy ]
  before_action :set_customer, only: [:index, :search, :new , :edit, :delete, :detroy]
  before_action :set_model_new, only: [:new]

  # GET/POST /customer_management/customer_locations/search
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

  # GET /customer_management/customer_locations
  # GET /customer_management/customer_locations.json 
  def index
    if user_permission.include?(24)
      @list_customer_locations = CustomerLocation.where("deleted = 0 AND customer_id = ?",params[:customer_id]).order("name ASC")    
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end
  
  # GET /customer_management/customer_locations/new
  def new
    if user_permission.include?(24)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /customer_management/customer_locations/1/edit
  def edit
    if user_permission.include?(24)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /customer_management/customer_locations
  # POST /customer_management/customer_locations.json
  def create
    @customer_location = CustomerLocation.new(model_params)
    if @customer_location.save
      flash[:notice] = 'Se guardó correctamente la ubicación.'
      flash[:type_message] = 'success' 
      redirect_to customer_management_customer_customer_locations_path(@customer_location.customer_id )
    else
      flash[:notice] = 'No se puede guardar porque la ubicación ya existe.'
      flash[:type_message] = 'danger'
      redirect_to new_customer_management_customer_customer_location_path(@customer_location.customer_id )
    end 
  end

  # PATCH/PUT /customer_management/customer_locations/1
  # PATCH/PUT /customer_management/customer_locations/1.json
  def update
    if @customer_location.update(model_params)
      flash[:notice] = 'Se actualizó correctamente la ubicación.'
      flash[:type_message] = 'success'
      redirect_to customer_management_customer_customer_locations_path(@customer_location.customer_id )
    else
      flash[:notice] = 'No se puede guardar porque la ubicación ya existe.'
      flash[:type_message] = 'danger'
      redirect_to edit_customer_management_customer_customer_location_path(@customer_location.customer_id,@customer_location.id )
    end
  end

  # GET /customer_management/customer_locations/1/delete
  def delete
    if user_permission.include?(24)
      @customer_location = CustomerLocation.find(params[:customer_location_id])
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # DELETE /customer_management/customer_locations/1
  # DELETE /customer_management/customer_locations/1.json  
  def destroy
    if user_permission.include?(24)
      @customer_location.update_attribute(:deleted,1)
      flash[:notice] = 'Se ha eliminado la ubicación.'
      flash[:type_message] = 'danger'    
      redirect_to customer_management_customer_customer_locations_path(@customer_location.customer_id )      
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @customer_location = CustomerLocation.find(params[:id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_model_new
      @customer_location = CustomerLocation.new
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_customer
       @customer = Customer.find(params[:customer_id] )
       @list_customer_locations =CustomerLocation.where('deleted= 0 AND customer_id = ?',@customer.id)
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:customer_location).permit!
    end
end