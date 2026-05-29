class CustomerManagement::DataCustomersController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy]
  before_action :set_new_model, only: [:index, :search, :new]
  before_action :set_select, only: [:index, :search]

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

      @list_substations = CustomerSubstation.where("deleted = 0").includes(:customer_area, :customer=>[:country] , :customer_area=>[:customer_location]).order("name ASC")         


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
    def set_new_model
      @customer = Customer.new
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_select
      @customers = Customer.where(deleted: 0)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:customer).permit!
     
    end
end
