class JsonManagement::DashboardUsersController < ApplicationController
 
  # GET /json_management/transformers
  # GET /json_management/transformers.json 
  def index

    @user_customers = UserCustomer.where('user_id IN (?)',current_user.id)

    # Ransack search params
    @search_customer = params[:search_customer]
  
    # Ransack search
    @query = Transformer.includes(:customer_substation).ransack(params[:q])

    # Ransack conditions
    @query.deleted_eq = 0
    @query.customer_substation_customer_id_in =  @user_customers.map { |e| e.customer_id }  if @search_customer.nil? or @search_customer.to_i == 0
    @query.customer_substation_customer_id_eq =  @search_customer if @search_customer.to_i > 0
    @results =  @query.result(distinct: true) 
    
    # Final result
    @registry_trafos = @results

  end

  def show

    # Ransack search params
    @search_customer = params[:id]
  
    # Ransack search
    @query = Transformer.includes(:customer_substation).ransack(params[:q])

    # Ransack conditions
    @query.deleted_eq = 0
    @query.customer_substation_customer_id_eq =  @search_customer 
    @results =  @query.result(distinct: true) 
    
    # Final result
    @registry_trafos = @results

  end


end 