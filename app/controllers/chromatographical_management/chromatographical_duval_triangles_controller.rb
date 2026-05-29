class ChromatographicalManagement::ChromatographicalDuvalTrianglesController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: %i[ show edit update destroy ]
 
  # PATCH/PUT /
  def update
    @chromatographical_duval.update(model_params)
    redirect_to duval_management_transformer_last_triangle_graphs_path(@chromatographical_duval.transformer_id)
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
