class ElectricalManagement::ElectricalsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy]
  before_action :set_table, only: [:show]


  # GET/POST /electrical_management/electricals
  def search
    if user_permission.include?(63)
      index
      render :index
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end     
  end

  # GET /electrical_management/electricals
  # GET /electrical_management/electricals.json 
  def index
    if user_permission.include?(63)
    #  @transformers = Transformer.where(deleted: 0)
      @transformer = Transformer.find(params[:transformer_id] )
      @electrical_transformers = Electrical.where(transformer_id: params[:id], deleted: 0 ).order('date_rehearsal DESC')
      # Ransack search params
      @search_transformer = params[:search_transformer]
      @search_tag = params[:search_tag]
 
      # Ransack search
      @query = Electrical.ransack(params[:q])
      # Ransack conditions
      @query.deleted_eq = 0
      @query.transformer_id_eq = 1
      @query.num_tag_eq =   @search_tag if @search_tag.present?
 
      # Order and pagination
      @results =  @query.result(distinct: true).order("customer_id ASC").paginate(:page => params[:page] )
      # Final result
      @list_transformers = @results

    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end
 
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @electrical = Electrical.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:electrical).permit!
    end
end