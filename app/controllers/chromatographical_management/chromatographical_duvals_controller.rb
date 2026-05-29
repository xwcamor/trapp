class ChromatographicalManagement::ChromatographicalDuvalsController < ApplicationController
  before_action :set_model, only: %i[ show edit update destroy ]

  # GET /
  def index
    @chromatographical_duvals = ChromatographicalDuval.where(deleted: 0)
  end

  # GET /
  def edit
     @chromatographical_duval = ChromatographicalDuval.find_by_transformer_id(params[:id])
     @chromatographicals  = Chromatographical.where("deleted=0 AND transformer_id = ?",params[:id] ).order("date_rehearsal ASC").last
     @last_chromatographical  = Chromatographical.find(@chromatographicals.id)
  end

  # PATCH/PUT /
  def update
    @chromatographical_duval.update(model_params)
    redirect_to chromatographical_management_transformer_chromatographicals_path(@chromatographical_duval.transformer_id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @chromatographical_duval =ChromatographicalDuval.find_by_transformer_id(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def model_params
      params.require(:chromatographical_duval).permit!
    end
end
