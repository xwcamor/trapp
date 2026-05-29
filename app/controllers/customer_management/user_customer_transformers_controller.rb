class CustomerManagement::UserCustomerTransformersController < ApplicationController
  before_action :authenticate_user
 
 
  # GET /customer_management/customers
  # GET /customer_management/customers.json 
  def index
    #if user_permission.include?(24)
      @user_customers =  UserCustomer.where('user_id=?',current_user.id)
      @substations = CustomerSubstation.where("deleted= 0 AND customer_id IN (?)",@user_customers.map { |e| e.customer_id }).order("name ASC")
      @transformers = Transformer.includes(:customer_substation).where("customer_substation_id IN (?)",@substations.map { |e| e.id })

      respond_to do |format|
        format.html
        format.json
      end 
    #else
    #  flash[:notice] = "No tienes acceso."
    #  flash[:type_message] = 'danger'
    #  redirect_to [:user_management,:authentications]
    #end
  end
end