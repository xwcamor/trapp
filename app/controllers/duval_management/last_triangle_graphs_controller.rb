class DuvalManagement::LastTriangleGraphsController < ApplicationController
  before_action :authenticate_user
  before_action :display_tansformer, only: [:index]  
  before_action :last_chromatographical, only: [:index]
  before_action :list_chromatographicals, only: [:index]  
  before_action :display_duval_text, only: [:index]
  before_action :chromatographical_duval_text, only: [:index]
  
  # GET /pot_management/pots/graphs
  def index
    if user_permission.include?(46)

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
    def last_chromatographical
       @last_chromatographical = Chromatographical.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal DESC').first
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def list_chromatographicals
       @list_chromatographicals = Chromatographical.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal DESC').limit(1)
    end

    # Use callbacks to share common setup or constraints between actions.
    def chromatographical_duval_text 
      @chromatographical_duval = ChromatographicalDuval.where(transformer_id: params[:transformer_id]).first
    end

    # Use callbacks to share common setup or constraints between actions.
    def display_duval_text
       @duval_type1 = Duval.where(duval_type_id: 1, graph_type: 1)
       @duval_type4 = Duval.where(duval_type_id: 1, graph_type: 4)
       @duval_type5 = Duval.where(duval_type_id: 1, graph_type: 5)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:chromatographical).permit!
    end
end
