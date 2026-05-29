class PhysicalManagement::ReportIeeeGraphsController < ApplicationController
  #before_action :authenticate_user
  before_action :display_tansformer, only: [:index]  
  before_action :display_physicals, only: [:index]
  before_action :display_physical_trial, only: [:index]  
  before_action :last_physical, only: [:index]

  # GET /pot_management/pots/graphs
  def index
      render :layout => false
      @posts = Post.where("transformer_id = ?",params[:transformer_id])
      @physical_posts = PhysicalPost.where("transformer_id = ?",params[:transformer_id])
   
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def display_tansformer
       @transformer = Transformer.find(params[:transformer_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def last_physical
       @last_physical = Physical.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal ASC').last
    end

    # Use callbacks to share common setup or constraints between actions.
    def display_physicals
       @graphic_physicals = Physical.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal ASC')
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def display_physical_trial
       @physical_trials = PhysicalTrial.where(transformer_test_id: 2)
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:physical).permit!
    end
end