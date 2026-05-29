class PhysicalManagement::TablePhysicalsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model,      only: [  :new]
 
  # GET /physical_management/physicals/new
  def new
    if user_permission.include?(50)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # POST /physical_management/physicals
  # POST /physical_management/physicals.json
  def create
    @physical = Physical.new(model_params)
    if @physical.save
      flash[:notice] = 'Se guardaron los datos del Análisis Físico Químico.'
      flash[:type_message] = 'success'
      redirect_to physical_management_transformer_physicals_path(@physical.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Análisis Físico Químico, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to physical_management_transformer_physicals_path(@physical.transformer_id)
    end 
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @transformer = Transformer.find(params[:transformer_id] )
      #@physical = Physical.new
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:physical).permit!
    end
end