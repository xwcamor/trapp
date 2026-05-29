class CustomerManagement::CustomerSubstationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy ]
  before_action :set_customer, only: [:index, :search, :new , :edit, :delete, :detroy]
  before_action :set_model_new, only: [:new]  
  
  # GET/POST /customer_management/customer_substations/search
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

  # GET /customer_management/customer_substations
  # GET /customer_management/customer_substations.json 
  def index
    if user_permission.include?(24)
      @list_customer_substations = CustomerSubstation.where("deleted = 0 AND customer_id = ?",params[:customer_id]).includes(:customer_area, :customer_area=>:customer_location).order("name ASC")         
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /customer_management/customer_substations/new
  def new
    if user_permission.include?(24)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /customer_management/customer_substations/1/edit
  def edit
    if user_permission.include?(24)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /customer_management/customer_substations
  # POST /customer_management/customer_substations.json
  def create
    @customer_substation = CustomerSubstation.new(model_params)
    if @customer_substation.save
      flash[:notice] = 'Se guardó correctamente la subestación.'
      flash[:type_message] = 'success' 
      redirect_to customer_management_customer_customer_substations_path(@customer_substation.customer_id )
    else
      flash[:notice] = 'No se puede guardar porque la subestación ya existe.'
      flash[:type_message] = 'danger'
      redirect_to new_customer_management_customer_customer_substation_path(@customer_substation.customer_id )
    end 
  end

  # PATCH/PUT /customer_management/customer_substations/1
  # PATCH/PUT /customer_management/customer_substations/1.json
  def update
    if @customer_substation.update(model_params)
      flash[:notice] = 'Se actualizó correctamente la subestación.'
      flash[:type_message] = 'success'
      redirect_to customer_management_customer_customer_substations_path(@customer_substation.customer_id )
    else
      flash[:notice] = 'No se puede guardar porque la subestación ya existe.'
      flash[:type_message] = 'danger'
      redirect_to edit_customer_management_customer_customer_substation_path(@customer_substation.customer_id,@customer_substation.id )
    end
  end

  # GET /customer_management/customer_areas/1/delete
  def delete
    if user_permission.include?(24)
      @customer_substation = CustomerSubstation.find(params[:customer_substation_id])
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # DELETE /customer_management/customer_substations/1
  # DELETE /customer_management/customer_substations/1.json  
  def destroy
    if user_permission.include?(24)
      @customer_substation.update_attribute(:deleted,1)
      flash[:notice] = 'Se ha eliminado la ubicación.'
      flash[:type_message] = 'danger'    
      redirect_to customer_management_customer_customer_substations_path(@customer_substation.customer_id )        
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @customer_substation = CustomerSubstation.find(params[:id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_model_new
      @customer_substation = CustomerSubstation.new
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_customer
       @customer = Customer.find(params[:customer_id] )
       @list_customer_substations =CustomerSubstation.where('deleted= 0 AND customer_id = ?',@customer.id)
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:customer_substation).permit!
    end
end
