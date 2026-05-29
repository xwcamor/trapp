class ChromatographicalManagement::ChromatographicalDgaDiagsController < ApplicationController
  before_action :set_model, only: %i[ show edit update destroy ]

  # GET /
  def index
    @chromatographical_dga_diags = ChromatographicalDgaDiag.where(deleted: 0)
  end

  # GET /
  def edit
     #@chromatographical_dga_diag =ChromatographicalDgaDiag.find(params[:id])
  end

  # PATCH/PUT /
  def update
    #@last_chromatographical_dga_diag = ChromatographicalDgaDiag.where(transformer_id: params[:id]).last
    @last_chromatographical_dga_diag = ChromatographicalDgaDiag.find_by(transformer_id: params[:id])
    @chromatographical_dga_diag.update(model_params)

     respond_to do |format|
        format.js
     end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      #@chromatographical_dga_diag =ChromatographicalDgaDiag.find(params[:id])
      @chromatographical_dga_diag = ChromatographicalDgaDiag.find_by(transformer_id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def model_params
      params.require(:chromatographical_dga_diag).permit!
    end
end
