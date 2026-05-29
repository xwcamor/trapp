class DevanadoManagement::IeeeGraphsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model_transformer, only: [:index, :search  ]

  # GET/POST /furano_management/furanos/search
  def search
    if user_permission.include?(56)
      index
      render :index
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end     
  end

  # GET /furano_management/furanos
  # GET /furano_management/furanos.json 
  def index
    if user_permission.include?(56)

      @devanado_template_transformer = DevanadoTemplateTransformer.find_by_transformer_id(@transformer.id) 
      @devanado_template = DevanadoTemplate.find_by_id(@devanado_template_transformer.devanado_template_id)
      @devanado_template_details = DevanadoTemplateDetail.where("devanado_template_id = ?",@devanado_template.id)
      @devanado_template_details_flow_1 = DevanadoTemplateDetail.where("devanado_template_id = ? AND devanado_flow_id = 1",@devanado_template.id)
      @devanado_template_details_flow_2 = DevanadoTemplateDetail.where("devanado_template_id = ? AND devanado_flow_id = 2",@devanado_template.id)
      @devanado_template_details_flow_3 = DevanadoTemplateDetail.where("devanado_template_id = ? AND devanado_flow_id = 3",@devanado_template.id)
      @devanado_template_details_flow_4 = DevanadoTemplateDetail.where("devanado_template_id = ? AND devanado_flow_id = 4",@devanado_template.id)

      @devanado_details = DevanadoDetail.joins(:devanado).where("devanados.deleted= 0 AND devanados.transformer_id = ?",@transformer.id).order("date_rehearsal ASC")
      @devanados = Devanado.where("deleted= 0 AND transformer_id = ?",@transformer.id).order("date_rehearsal DESC")
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model_transformer
      @transformer = Transformer.find(params[:transformer_id] )
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:ieee_diag).permit!
    end

end