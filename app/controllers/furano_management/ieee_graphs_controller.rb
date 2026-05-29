class FuranoManagement::IeeeGraphsController < ApplicationController
  before_action :authenticate_user
  before_action :display_tansformer, only: [:index]  
  before_action :display_furanos, only: [:index]

  # GET /pot_management/pots/graphs
  def index
    if user_permission.include?(62)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def display_tansformer
       @transformer = Transformer.find(params[:transformer_id])
    end
 
    # Use callbacks to share common setup or constraints between actions.
    def display_furanos
       @graphic_furanos = Furano.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal ASC')
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:furano).permit!
    end
end