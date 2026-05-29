class CustomerManagement::UserCustomerLocationsController < ApplicationController
  before_action :authenticate_user
 
 
  # GET /customer_management/customers
  # GET /customer_management/customers.json 
  def index
    #if user_permission.include?(24)
      @user_customers =  UserCustomer.where('user_id=?',current_user.id)
      @locations = CustomerLocation.where("deleted= 0 AND customer_id IN (?)",@user_customers.map { |e| e.customer_id }).order("name ASC")
      
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