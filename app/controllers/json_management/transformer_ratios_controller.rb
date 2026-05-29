class JsonManagement::TransformerRatiosController < ApplicationController
 
  # GET /json_management/transformers
  # GET /json_management/transformers.json 
  def index
      # Ransack search
      @user_customers = UserCustomer.joins(:customer).where('user_customers.user_id=?',current_user.id).order("customers.country_id DESC, customers.name")
      @customer_substations = CustomerSubstation.where("deleted=0 AND customer_id IN (?)",@user_customers.map { |e| e.customer_id })
      @list_transformers = Transformer.includes(:transformer_preservation,:oil_type,:connection_type,:conmutation_type,:transformer_type,:mark, :customer_substation=> [ :customer_area, :customer_area=> [ :customer_location =>[:customer =>[:country] ] ] ] ).where("deleted=0 AND customer_substation_id IN (?)",@customer_substations.map { |e| e.id })     
  end


end 