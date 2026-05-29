class UserManagement::SearchTransformerPerUsersController < ApplicationController
  before_action :authenticate_user 
  before_action :set_model, only: [:show ]

  def new
    @search = SearchTransformerPerUser.new
    @user_customers = UserCustomer.where('user_id IN (?)',current_user.id)
    @condicion = UserCustomer.where('user_id=?',current_user.id).length 
    

    # Ransack search
    @query = Transformer.includes(:customer_substation).ransack(params[:q])
    
    # Ransack conditions
    @query.deleted_eq = 0
    @query.customer_substation_customer_id_in =  @user_customers.map { |e| e.customer_id } 
    @results =  @query.result(distinct: true) 
        
    # Final result with more than 1 customer assigned
    @registry_trafos = @results
    # Final result with 1 customer assigner
    @query_one = Transformer.joins(:customer_substation).where("transformers.deleted = 0 AND customer_substations.customer_id IN (?)",@user_customers.map { |a| a.customer_id  })
    @registry_trafos_one = @query_one    
  end

  def create
    @search = SearchTransformerPerUser.new(model_params)
    if @search.save
      flash[:notice] = 'Se ha creado la búsqueda de Transformadores por Cliente.'
      flash[:type_message] = 'success'
      redirect_to user_management_search_transformer_per_user_path(@search)
    else
      flash[:notice] = 'Por Favor seleccione 1 transformador como mínimo.'
      flash[:type_message] = 'danger'
      redirect_to new_user_management_search_transformer_per_user_path
    end     
  end

  def show
 
    @user_customers = UserCustomer.where('user_id IN (?)',current_user.id)
    @condicion = UserCustomer.where('user_id=?',current_user.id).length 

    # Ransack search
    @query = Transformer.includes(:customer_substation).ransack(params[:q])
    
    # Ransack conditions
    @query.deleted_eq = 0
    @query.customer_substation_customer_id_eq =  @search.customer_id
    @query.id_in = @search.transformer_id
    @results =  @query.result(distinct: true) 

        
    # Final result with more than 1 customer assigned
    @registry_trafos = @results
    # Final result with 1 customer assigner
    @query_one = Transformer.joins(:customer_substation).where("transformers.deleted = 0 AND customer_substations.customer_id IN (?)",@user_customers.map { |a| a.customer_id  })
    @registry_trafos_one = @query_one      
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @search = SearchTransformerPerUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:search_transformer_per_user).permit!
    end

end