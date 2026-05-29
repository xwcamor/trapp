class ChromatographicalManagement::TableChromatographicalsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:index, :search, :new]
  before_action :display_gas, only: [:index, :search, :show, :new,  :edit,   :create, :update]
  before_action :set_model_nested, only: [ :show, :edit, :update, :destroy]
  before_action :save_duval_info, only: [:index, :search]
 

  # GET /chromatographical_management/chromatographicals/new
  def new
    if user_permission.include?(41)
      @chromatographical = Chromatographical.new
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end
 

  # POST /chromatographical_management/chromatographicals
  # POST /chromatographical_management/chromatographicals.json
  def create
    @chromatographical = Chromatographical.new(model_params)
    if @chromatographical.save
      flash[:notice] = 'Se guardaron los datos del Análisis Cromatografico.'
      flash[:type_message] = 'success'
      redirect_to chromatographical_management_transformer_chromatographicals_path(@chromatographical.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Análisis Cromatografico, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to chromatographical_management_transformer_chromatographicals_path(@chromatographical.transformer_id)
    end 
  end
 
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @transformer = Transformer.find(params[:transformer_id] )
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_model_nested
      @chromatographical = Chromatographical.find(params[:id] )
    end

    # Use callbacks to share common setup or constraints between actions.
    def display_gas
      @gas = Gas.where('transformer_test_id = 1')
    end

    # Use callbacks to share common setup or constraints between actions.
    def save_duval_info
      @last_chromatographical = Chromatographical.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal ASC').last
      @chromatographical_duval = ChromatographicalDuval.where(transformer_id: params[:transformer_id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:chromatographical).permit!
    end
end
