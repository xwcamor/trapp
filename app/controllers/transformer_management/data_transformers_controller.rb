class TransformerManagement::DataTransformersController < ApplicationController
  before_action :authenticate_user
  
  # GET/POST /teacher_management/teachers
  def search
    if user_permission.include?(31)
      index
      render :index
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /transformer_management/transformers
  # GET /transformer_management/transformers.json 
  def index
    if user_permission.include?(31)
      # Ransack search
      @user_customers = UserCustomer.joins(:customer).where('user_customers.user_id=?',current_user.id).order("customers.country_id DESC, customers.name")
      @customer_substations = CustomerSubstation.where("deleted=0 AND customer_id IN (?)",@user_customers.map { |e| e.customer_id })
      @condicion = UserCustomer.where('user_id=?',current_user).length 
      @list_transformers = Transformer.includes(:transformer_preservation,:oil_type,:connection_type,:conmutation_type,:transformer_type,:mark, :customer_substation=> [ :customer_area, :customer_area=> [ :customer_location =>[:customer =>[:country] ] ] ] ).where("deleted=0 AND customer_substation_id IN (?)",@customer_substations.map { |e| e.id })
   
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end
 
end
