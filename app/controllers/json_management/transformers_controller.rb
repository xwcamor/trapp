class JsonManagement::TransformersController < ApplicationController
 
  # GET /json_management/transformers
  # GET /json_management/transformers.json 
  def index
      # Ransack search
      @current_profile = current_user.profile_id
      @profile_countries = ProfileCountry.where("profile_id = ?",@current_profile)    

      @user_customers = UserCustomer.joins(:customer).where('user_customers.user_id=? AND customers.country_id IN (?)',current_user.id, @profile_countries.map { |e| e.country_id }).order("customers.country_id DESC, customers.name")
      @customer_substations = CustomerSubstation.where("deleted=0 AND customer_id IN (?)",@user_customers.map { |e| e.customer_id })
      @list_transformers = Transformer.includes(:transformer_preservation,:oil_type,:connection_type,:conmutation_type,:transformer_type,:mark, :customer_substation=> [ :customer_area, :customer_area=> [ :customer_location =>[:customer =>[:country] ] ] ] ).where("deleted=0 AND customer_substation_id IN (?)",@customer_substations.map { |e| e.id })     
  end


end 