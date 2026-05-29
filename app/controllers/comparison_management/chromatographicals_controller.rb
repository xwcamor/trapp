class ComparisonManagement::ChromatographicalsController < ApplicationController
  before_action :authenticate_user


  def show
    if user_permission.include?(149)
      redirect_back(fallback_location: step1_comparison_management_chromatographicals_url)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end  
  end

  # GET/POST /teacher_management/teachers
  def step2
    if user_permission.include?(149)
      if params[:transformer_ids].nil?
        redirect_back(fallback_location: step1_comparison_management_chromatographicals_url)
      else
        @search_tramsformers = params[:transformer_ids]
        @list_transformers = Transformer.where("id IN (?)",@search_tramsformers)        
      end
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end      
  end
  
  def step1
    if user_permission.include?(149)

      # Ransack search
      #@user_customers = UserCustomer.joins(:customer).where('user_customers.user_id=?',current_user.id).order("customers.country_id DESC, customers.name")
      #@customer_substations = CustomerSubstation.where("deleted=0 AND customer_id IN (?)",@user_customers.map { |e| e.customer_id })
      #@user_transformers = Transformer.includes(:transformer_preservation,:oil_type,:connection_type,:conmutation_type,:transformer_type,:mark, :customer_substation=> [ :customer_area, :customer_area=> [ :customer_location =>[:customer =>[:country] ] ] ] ).where("deleted=0 AND customer_substation_id IN (?)",@customer_substations.map { |e| e.id })

      # Ransack search params
      @search_transformer = params[:search_transformer]
 
      # Ransack search
      @query = Transformer.ransack(params[:q])
      # Ransack conditions
      #@query.id_in = @user_transformers.map { |e| e.id }
      @results =  @query.result(distinct: true)#.order("date_rehearsal DESC").paginate(:page => params[:page] )
      # Final result
      @list_transformers = @results


    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end  	
  end
end