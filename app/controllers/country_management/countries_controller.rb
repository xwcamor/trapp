class CountryManagement::CountriesController < ApplicationController
  before_action :authenticate_user
 
 
  # GET /customer_management/customers
  # GET /customer_management/customers.json 
  def index
    #if user_permission.include?(24)
      @countries = Country.where("deleted= 0").order("name ASC")
      
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