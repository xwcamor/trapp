class ChromatographicalManagement::GasKeysController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy ]
  
  # GET /chromatographical_management/chromatographicals
  # GET /chromatographical_management/chromatographicals.json 
  def index
    if user_permission.include?(83)
      @gas_key = GasKey.new
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end
 
  # POST /chromatographical_management/chromatographicals
  # POST /chromatographical_management/chromatographicals.json
  def create
    @gas_key = GasKey.new(model_params)
    if @gas_key.save
      flash[:notice] = 'Se envió el Gas Clave al Resumen.'
      flash[:type_message] = 'success'
      redirect_to duval_management_transformer_silicona_graphs_path(@gas_key.transformer_id)
    else
      flash[:notice] = 'Se envió el Gas Clave al Resumen.'
      flash[:type_message] = 'danger'
      redirect_to duval_management_transformer_silicona_graphs_path(@gas_key.transformer_id)
    end 
  end

  # PATCH/PUT /chromatographical_management/chromatographicals/1
  # PATCH/PUT /chromatographical_management/chromatographicals/1.json
  def update
    if @gas_key.update(model_params)
      flash[:notice] = 'Se envió el Gas Clave al Resumen.'
      flash[:type_message] = 'success'
      redirect_to duval_management_transformer_silicona_graphs_path(@gas_key.transformer_id)
    else
      flash[:notice] = 'Se envió el Gas Clave al Resumen.'
      flash[:type_message] = 'danger'
      redirect_to duval_management_transformer_silicona_graphs_path(@gas_key.transformer_id)
    end
  end
  
  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @gas_key = GasKey.find(params[:id] )
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:gas_key).permit!
    end
end