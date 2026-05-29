class UserManagement::TransformersController < ApplicationController
  before_action :authenticate_user, :only => [:index ]
  
  # GET /user_management/transformers/search
  def search
    index
    render :index
  end

  # GET /user_management/transformers
  def index

    @user_customers = UserCustomer.where('user_id IN (?)',current_user.id)
    @condicion = UserCustomer.where('user_id=?',current_user.id).length 
    
    # Ransack search params
    @search_customer = params[:search_customer]
    @search_transformer = params[:search_transformer]

    # Ransack search
    @query = Transformer.includes(:customer_substation).ransack(params[:q])
    
    # Ransack conditions
    @query.deleted_eq = 0
    @query.customer_substation_customer_id_in =  @user_customers.map { |e| e.customer_id }  if @search_customer.nil? or @search_customer.to_i == 0
    @query.customer_substation_customer_id_eq =  @search_customer if @search_customer.to_i > 0
    @query.id_in =  @search_transformer   if @search_transformer.present?
    @results =  @query.result(distinct: true) 
        
    # Final result with more than 1 customer assigned
    @registry_trafos = @results
    # Final result with 1 customer assigner
    @query_one = Transformer.joins(:customer_substation).where("transformers.deleted = 0 AND customer_substations.customer_id IN (?)",@user_customers.map { |a| a.customer_id  })
    @registry_trafos_one = @query_one

  end
 
end