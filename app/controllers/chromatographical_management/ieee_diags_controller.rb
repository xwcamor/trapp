class ChromatographicalManagement::IeeeDiagsController < ApplicationController
  before_action :authenticate_user
 
  #################################################

  def index
    if user_permission.include?(84)
      @transformer = Transformer.find(params[:transformer_id])
      @list_ieee_diags = IeeeDiag.where("deleted= 0 AND transformer_id = ?",@transformer.id )
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  ###############################################

  def new
    if user_permission.include?(84)
      @ieee_diag = IeeeDiag.new
      @transformer = Transformer.find(params[:transformer_id])
      @chromatographicals = Chromatographical.where('deleted= 0 AND transformer_id = ?',@transformer.id).order('date_rehearsal DESC')
      
      @ieee_diags = IeeeDiagDetail.all
      @job_remover = IeeeDiagDetail.joins(ieee_diag: :transformer).where("transformer_id = ?",@transformer.id ).destroy_all
      @job_remover2 = IeeeDiag.where("deleted = 1 AND deleted= 2").destroy_all
      @job_remover3 = IeeeDiag.where("transformer_id = ?",@transformer.id).destroy_all

    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  ###############################################
  
  def create
    @transformer = Transformer.find(params[:ieee_diag][:transformer_id])
    @ieee_diag = IeeeDiag.new(model_params)
    @chromatographicals = Chromatographical.where('deleted= 0 AND transformer_id = ?',@transformer.id).order('date_rehearsal DESC')
    
    if @ieee_diag.save
      @chromatographicals.each do |chromatographical|
        if params["chromatographical_"+chromatographical.id.to_s] == "on"
          ieee_diag_detail = IeeeDiagDetail.new
          ieee_diag_detail.chromatographical_id = chromatographical.id
          ieee_diag_detail.ieee_diag_id = @ieee_diag.id
          ieee_diag_detail.save
        end
      end
        
      @condition= IeeeDiagDetail.where(ieee_diag_id: @ieee_diag.id).count
      if @condition.to_i == 3 or @condition.to_i == 4 or @condition.to_i == 5 or @condition.to_i == 6
        flash[:notice] = 'Mostrando Cálculos'
        flash[:type_message] = 'success'
        redirect_to chromatographical_management_ieee_diag_path(@ieee_diag)
      else
        @ieee_diag.ieee_diag_details.destroy
        @job_remover2 = IeeeDiag.where("deleted = 1 AND deleted= 2").destroy_all
        flash[:notice] = 'Por favor seleccione entre 3 a 6 registros .'
        flash[:type_message] = 'danger'
        redirect_to new_chromatographical_management_transformer_ieee_diag_path(@transformer)
      end
    else
      flash[:notice] = 'Error al crear.'
      flash[:type_message] = 'danger'
      redirect_to chromatographical_management_transformer_ieee_diags_path(@transformer)
    end
  end

  #############################################

  def show
    if user_permission.include?(151)

      @ieee_diag = IeeeDiag.find(params[:id])
      @transformer = Transformer.find(@ieee_diag.transformer_id)
      @ieee_diag_details = IeeeDiagDetail.where('ieee_diag_id = ?', @ieee_diag.id) 
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

###############################################

  def edit

    if user_permission.include?(84)

      @ieee_diag = IeeeDiag.find(params[:id])
      @transformer = Transformer.find(@ieee_diag.transformer_id)
      @ieee_diag_details = IeeeDiagDetail.where('ieee_diag_id = ?', @ieee_diag.id) 

    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end

  end

###############################################
  
  def update

    @ieee_diag = IeeeDiag.find(params[:id])
    @transformer = Transformer.find(@ieee_diag.transformer_id)
    @ieee_diag_details = IeeeDiagDetail.where('ieee_diag_id = ?', @ieee_diag.id) 
    
    if @ieee_diag.update(model_params)


      @condition= IeeeDiag.find(params[:id])

      if @condition.ppm_hid.to_i == 18791879 # caso guardar limites
        flash[:notice] = 'Mostrando limites del diagnóstico.'
        flash[:type_message] = 'success'
        redirect_to chromatographical_management_ieee_diag_path(@ieee_diag)   

      elsif @condition.month_period.to_i == 18791879  # caso omitir tabla 4
        flash[:notice] = 'Se guardò el diagnóstico omitir Tabla 4.'
        flash[:type_message] = 'success'
        redirect_to [:transformer_management, @transformer]   

      elsif @condition.month_period.to_i > 3 && @condition.month_period.to_i < 25  # caso rangos 3 a 24 meses
        flash[:notice] = 'Se guardò el diagnóstico periodo de la Tabla 4.'
        flash[:type_message] = 'success'
        redirect_to [:transformer_management, @transformer]

      else
        @ieee_diag = IeeeDiag.find(params[:id])
        @ieee_diag.deleted = 1
        @ieee_diag.save
        flash[:notice] = 'El Periodo se debe encontrar entre 4 a 24 meses. Por favor omitir Tabla 4 ó diagnosticar de nuevo'
        flash[:type_message] = 'danger'
        redirect_to chromatographical_management_ieee_diag_path(@ieee_diag)
      end
            
         
    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      render :edit
    end

  

  end
  

################################################ 

  def destroy

    if user_permission.include?(38)
       @ieee_diag = IeeeDiag.find(params[:id])
      @ieee_diag.update_attribute(:deleted,1)
      flash[:notice] = 'Se eliminó el diagnóstico de la Tabla 4'
      flash[:type_message] = 'danger'
      redirect_to transformer_management_transformer_path(@ieee_diag.transformer_id)     

    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end

  end

###############################################

  private
    def model_params
       params.require(:ieee_diag).permit!
    end

################################################

end
