class ChromatographicalManagement::ReportIeeeGraphsController < ApplicationController
  #before_action :authenticate_user
  before_action :display_tansformer, only: [:index]  
  before_action :display_chromatographicals, only: [:index]
  before_action :display_gas, only: [:index]  
  before_action :last_chromatographical, only: [:index]

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
    def last_chromatographical
       @last_chromatographical = Chromatographical.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal ASC').last
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def display_chromatographicals
       @graphic_chromatographicals = Chromatographical.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal ASC')
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def display_gas
       @gas = Gas.where(transformer_test_id: 1)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:chromatographical).permit!
    end
end