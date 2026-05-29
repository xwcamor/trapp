class CustomerManagement::UserCustomersController < ApplicationController
  before_action :authenticate_user
 
 
  # GET /customer_management/customers
  # GET /customer_management/customers.json 
  def index
    #if user_permission.include?(24)
      @current_profile = current_user.profile_id
      @profile_countries = ProfileCountry.where("profile_id = ?",@current_profile)    

      #@user_customers =  UserCustomer.where('user_id=?',current_user.id)
      @user_customers = UserCustomer.joins(:customer).where('user_customers.user_id=? AND customers.country_id IN (?)',current_user.id, @profile_countries.map { |e| e.country_id }).order("customers.country_id DESC, customers.name")
      @customers = Customer.includes(:country).where("deleted= 0 AND id IN (?)",@user_customers.map { |e| e.customer_id }).order("name ASC")
      
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