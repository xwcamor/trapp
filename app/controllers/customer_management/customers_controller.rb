class CustomerManagement::CustomersController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update,   :destroy ]
  before_action :set_customer, only: [  :new , :edit , :delete]
  before_action :set_model_new, only: [:new]
  before_action :set_select, only: [:new, :edit]

  # GET/POST /customer_management/customers/search
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

  # GET /customer_management/customers
  # GET /customer_management/customers.json 
  def index
    if user_permission.include?(24)
      
      @current_profile = current_user.profile_id
      @profile_countries = ProfileCountry.where("profile_id = ?",@current_profile)

      @list_customers =  Customer.where("deleted= 0 AND country_id IN (?)",@profile_countries.map { |e| e.country_id }).includes(:country ).order("country_id,name ASC") 
      @customers = Customer.where("deleted= 0")
      
      respond_to do |format|
        format.html
        format.json
      end 
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /customer_management/customers/1
  # GET /customer_management/customers/1.json
  def show
    if user_permission.include?(25)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end
  
  # GET /customer_management/customers/new
  def new
    if user_permission.include?(26)
      @current_profile = current_user.profile_id
      @profile_countries = ProfileCountry.where("profile_id = ?",@current_profile)      

      @countries = Country.where("deleted= 0 AND id IN (?)",@profile_countries.map { |e| e.country_id })
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /customer_management/customers/1/edit
  def edit
    if user_permission.include?(27)
      @current_profile = current_user.profile_id
      @profile_countries = ProfileCountry.where("profile_id = ?",@current_profile)      

      @countries = Country.where("deleted= 0 AND id IN (?)",@profile_countries.map { |e| e.country_id })
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /customer_management/customers
  # POST /customer_management/customers.json
  def create
    @customer = Customer.new(model_params)
    if @customer.save
      flash[:notice] = 'Cliente registrado correctamente.'
      flash[:type_message] = 'success'
      redirect_to [:customer_management, @customer ]
    else
      flash[:notice] = 'El Cliente o Número de documento ya existe.'
      flash[:type_message] = 'danger'
      redirect_to new_customer_management_customer_path  
    end 
  end

  # PATCH/PUT /customer_management/customers/1
  # PATCH/PUT /customer_management/customers/1.json
  def update
    if @customer.update(model_params)
      flash[:notice] = 'Cliente actualizado correctamente'
      flash[:type_message] = 'success'
      redirect_to [:customer_management, :customers ]             
    else
      flash[:notice] = 'El Cliente o número de documento ya existe.'
      flash[:type_message] = 'danger'
      redirect_to edit_customer_management_customer_path(@customer) 
    end
  end
  
  # GET /customer_management/customers/1/delete
  def delete
    if user_permission.include?(28)
      @customer = Customer.find(params[:customer_id])
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # DELETE /customer_management/customers/1
  # DELETE /customer_management/customers/1.json  
  def destroy
    if user_permission.include?(28)
      @customer.update_attribute(:deleted,1)
      flash[:notice] = 'Se ha eliminado el Cliente.'
      flash[:type_message] = 'danger'    
      redirect_to customer_management_customers_path      
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @customer = Customer.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @list_customers =  Customer.where(deleted: 0)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_model_new
      @customer = Customer.new

    end

    # Use callbacks to share common setup or constraints between actions.
    def set_select
      @countries = Country.where(deleted: 0).order("name ASC")
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:customer).permit!
    end
end
