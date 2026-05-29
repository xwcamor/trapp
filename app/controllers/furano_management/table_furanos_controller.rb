class FuranoManagement::TableFuranosController < ApplicationController
  before_action :authenticate_user
  before_action :set_model,   only: [  :new]
 
  # GET /furano_management/furanos/new
  def new
    if user_permission.include?(104)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # POST /furano_management/furanos
  # POST /furano_management/furanos.json
  def create
    @furano = Furano.new(model_params)
    if @furano.save
      flash[:notice] = 'Se guardaron los datos del Furano.'
      flash[:type_message] = 'success'
      redirect_to furano_management_transformer_furanos_path(@furano.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Furano, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to furano_management_transformer_furanos_path(@furano.transformer_id)
    end 
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @transformer = Transformer.find(params[:transformer_id] )
      #@furano = Furano.new
    end
 
    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:furano).permit!
    end
end