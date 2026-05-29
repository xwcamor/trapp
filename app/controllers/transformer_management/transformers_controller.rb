class TransformerManagement::TransformersController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy]
  before_action :set_select, only: [ :new,:edit, :create, :update]
  before_action :set_model_new, only: [:new]
  before_action :set_model_count, only: [:new, :edit,:delete ]
  before_action :last_analysis_value, only: [:show ]
  before_action :save_dga_diag_info, only: [:show ]
  
  # GET/POST /teacher_management/teachers
  def search
    if user_permission.include?(31)
      index
      render :index
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /transformer_management/transformers
  # GET /transformer_management/transformers.json 
  def index
    if user_permission.include?(31)

      @profile = current_user.profile_id
      # Ransack search params
      @search_customer = params[:search_customer]
      @search_transformer = params[:search_transformer]
      
      if @profile.to_i == 1 or @profile.to_i == 8 #perfil 1 admin de sistema y 8 administradores
        @user_customers = UserCustomer.joins(:customer).where("customers.deleted = 0")
      else
        @user_customers = UserCustomer.joins(:customer).where('user_customers.user_id=?',current_user.id).order("customers.country_id DESC, customers.name")
      end

      # BEGIN Condition to get sustations from customer id param received
      if @search_customer.present?    
        @customer_substations = CustomerSubstation.where("deleted=0 AND customer_id = ?", @search_customer )
      else       
        @customer_substations = CustomerSubstation.where("deleted=0 AND customer_id IN (?)",@user_customers.map { |e| e.customer_id })
      end
      # END Condition to get sustations from customer id param received

      @condicion = UserCustomer.where('user_id=?',current_user).length 

      # Ransack search
      @query = Transformer.includes(:mark, :customer_substation=> [ :customer_area, :customer_area=> [ :customer_location =>[:customer =>[:country] ] ] ] ).where("deleted=0 AND customer_substation_id IN (?)",@customer_substations.map { |e| e.id }).ransack(params[:q])   
      @query.id_in =  @search_transformer   if @search_transformer.present?      
      @list_transformers =  @query.result
      #@list_transformers = Transformer.includes(:mark, :customer_substation=> [ :customer_area, :customer_area=> [ :customer_location =>[:customer =>[:country] ] ] ] ).where("deleted=0 AND customer_substation_id IN (?)",@customer_substations.map { |e| e.id }).ransack(params[:q])   
     
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /transformer_management/transformers/1
  # GET /transformer_management/transformers/1.json
  def show
    if user_permission.include?(32)
      @chromatographical =Chromatographical.where('deleted=0 AND transformer_id = ?',params[:id]).order('date_rehearsal DESC').first
      @physical =Physical.where('deleted=0 AND transformer_id = ?',params[:id]).order('date_rehearsal DESC').first
      
      @transformer_graphs = TransformerGraph.all
      respond_to do |format|
        format.html
    
        format.doc { 
          send_data render_to_string(
            :partial=>"transformer_management/transformers/partials/final_report"),
            :filename => "Reporte_completo_del_transformador_#{Time.now.strftime("%d_%m_%Y")}.doc"
          }     


        format.pdf  { 
          render :pdf => "Reporte_del_transformador_#{@transformer.num_serie}",
            layout: "pdf",
            #disable_javascript:             false,
            #viewport_size: '1280x1024',
            #disable_javascript:             false,
            #enable_plugins:                 true,
            #javascript_delay: 5000,            
            #disable_internal_links:         true,
            #disable_external_links:         true,
            #show_as_html: false,

            show_as_html:               params.key?('debug'), #  /file.pdf?debug
            margin:  {  top:     3,#20,    # default 10 (mm)
                        #left:   10,
                        #right:  10,
                        bottom:  30
            },
            #print_media_type: true  ,
            #header: { html: { template: 'layouts/pdf_header'},
                        #center:        '12',
                        #font_name:     '8px',
            #            font_size:      12,
                        # left:         'TEXT',
                        # right:        'TEXT',
                        # spacing:       REAL,
                        # line:          true
            #},
            footer: { html: { template: 'layouts/pdf_footer'},
                            #center:            '12',
                            #font_name:         '8px',
                            font_size:         12,
                            # left:              'TEXT',
                            # right:             'TEXT',
                            # spacing:           REAL,
                            # line:              true
            },
            #toc: true,
            # toc: {
            #                     text_size_shrink:  0.8,
            #                     header_text: "Tabla de Contenidos",
            #                     no_dots: false,
            #                     disable_dotted_lines: false,
            #                     disable_links: false,
            #                     disable_toc_links: false,
            #                     disable_back_links: false ,
            #                     #l1_indentation:    2,
            # },            
            :orientation => 'Portrait',:page_size => 'A4'   
        }  


      end            
    else
      flash[:notice] = "No tienes permiso para ver."
      flash[:type_message] = 'danger'
      redirect_back(fallback_location: transformer_management_transformers_url)
    end      
  end
  
  # GET /transformer_management/transformers/new
  def new
    if user_permission.include?(33)
    else
      flash[:notice] = "No tienes permiso para crear."
      flash[:type_message] = 'danger'
      redirect_back(fallback_location: transformer_management_transformers_url)
    end      
  end

  # GET /transformer_management/transformers/1/edit
  def edit
    if user_permission.include?(34)
      @customer_locations = CustomerLocation.where('customer_id = ?', @transformer.customer_substation.customer_id)
      @customer_areas = CustomerArea.where('customer_location_id =  ?', @transformer.customer_substation.customer_area.customer_location_id )
      @customer_substations = CustomerSubstation.where('customer_area_id = ?', @transformer.customer_substation.customer_area_id)
    else
      flash[:notice] = "No tienes permiso para editar."
      flash[:type_message] = 'danger'
      redirect_back(fallback_location: transformer_management_transformers_url)
    end         
  end

  # POST /transformer_management/transformers
  # POST /transformer_management/transformers.json
  def create
    @transformer = Transformer.new(model_params)
    if @transformer.save
      flash[:notice] = 'Se registró el transformador.'
      flash[:type_message] = 'success'
      redirect_to [:transformer_management, @transformer ]
    else
      flash[:notice] = 'Error al crear el transformador, ya que la serie está duplicada.'
      flash[:type_message] = 'danger'
      redirect_to new_transformer_management_transformer_path
    end 
  end

  # PATCH/PUT /transformer_management/transformers/1
  # PATCH/PUT /transformer_management/transformers/1.json
  def update
    if @transformer.update(model_params)
      if params[:transformer][:chromatographicals_attributes].present?  # validation for chromatographical params
         flash[:notice] = 'Se guardaron los datos del Análisis Cromatográfico.'
         flash[:type_message] = 'success'
         redirect_to chromatographical_management_transformer_chromatographicals_path(@transformer)  
         
      elsif params[:transformer][:physicals_attributes].present?  # validation for physical params
        flash[:notice] = 'Se guardaron los datos del Análisis Físico Químico.'
        flash[:type_message] = 'success'
        redirect_to physical_management_transformer_physicals_path(@transformer)    

      elsif params[:transformer][:furanos_attributes].present?  # validation for furano params
        flash[:notice] = 'Se guardaron los datos del Furano.'
        flash[:type_message] = 'success'
        redirect_to furano_management_transformer_furanos_path(@transformer)      

      elsif params[:transformer][:factors_attributes].present?  # validation for factor params
        flash[:notice] = 'Se guardaron los datos del Factor.'
        flash[:type_message] = 'success'
        redirect_to factor_management_transformer_factors_path(@transformer)               
      else  # validation for transformer params  
        redirect_to "/transformer_management/transformers/" + @transformer.id.to_s
      end
    else
      if params[:transformer][:chromatographicals_attributes].present?  #  redirect validation for chromatographical params
        flash[:notice] = 'Error al guardar los datos del Análisis Cromatográfico, ya hay 1 registro con la misma fecha.'
        flash[:type_message] = 'danger'
        redirect_to new_chromatographical_management_transformer_table_chromatographical_path(@transformer) 

      elsif params[:transformer][:physicals_attributes].present?  #  redirect validation for physical params
        flash[:notice] = 'Error al guardar los datos del Análisis Físico Químico, ya hay 1 registro con la misma fecha.'
        flash[:type_message] = 'danger'
        redirect_to new_physical_management_transformer_table_physical_path(@transformer)        

      elsif params[:transformer][:furanos_attributes].present?  #  redirect validation for furano params
        flash[:notice] = 'Error al guardar los datos del Furano, ya hay 1 registro con la misma fecha.'
        flash[:type_message] = 'danger'
        redirect_to new_furano_management_transformer_table_furano_path(@transformer)  

      elsif params[:transformer][:factors_attributes].present?  #  redirect validation for factor params
        flash[:notice] = 'Error al guardar los datos del Factor, ya hay 1 registro con la misma fecha.'
        flash[:type_message] = 'danger'
        redirect_to new_factor_management_transformer_table_factor_path(@transformer)     

      else  #  redirect validation for transformer params
        flash[:notice] = 'Error al actualizar el transformador.'
        flash[:type_message] = 'danger'
        redirect_to edit_transformer_management_transformer_path(@transformer) 
      end

    end
  end

  # GET /customer_management/customers/1/delete
  def delete
    if user_permission.include?(28)
      @transformer = Transformer.find(params[:transformer_id])
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # DELETE /transformer_management/transformers/1
  # DELETE /transformer_management/transformers/1.json  
  def destroy
    if user_permission.include?(35)
      @transformer.update_attribute(:deleted,1)
      flash[:notice] = 'Data eliminada'
      flash[:type_message] = 'success'
      redirect_to [:transformer_management,:transformers]
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  # GET /customer_management/customers/1/delete
  def edit_report
    if user_permission.include?(34)
      @transformer = Transformer.find(params[:transformer_id])
      @chromatographical = Chromatographical.where("deleted=0 AND transformer_id = ?",@transformer.id).order("date_rehearsal DESC").first
      @physical = Physical.where("deleted=0 AND transformer_id = ?",@transformer.id).order("date_rehearsal DESC").first

      @chromatographical_count = Chromatographical.where("deleted=0 AND transformer_id = ?",@transformer.id).order("date_rehearsal DESC").size
      @physical_count = Physical.where("deleted=0 AND transformer_id = ?",@transformer.id).order("date_rehearsal DESC").size
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end  

 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @transformer = Transformer.find(params[:id])
    end
    
    def set_model_new
      @transformer = Transformer.new
    end

    def set_model_count
      @user_customers = UserCustomer.where('user_id=?',current_user.id) 
      @customer_substations = CustomerSubstation.where("deleted=0 AND customer_id IN (?)",@user_customers.map { |e| e.customer_id })
      @list_transformers = Transformer.where("deleted=0 AND customer_substation_id IN (?)",@customer_substations.map { |e| e.id })
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_select
      @transformer_types = TransformerType.where(deleted: 0)
      @marks = Mark.where(deleted: 0)
      @conmutation_types = ConmutationType.where(deleted: 0)
      @connection_types = ConnectionType.where(deleted: 0)
      @oil_types = OilType.where(deleted: 0)
      @transformer_preservations = TransformerPreservation.where(deleted: 0)
    end

    # Use callbacks to share common setup or constraints between actions.
    def last_analysis_value
       @last_chromatographical = Chromatographical.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal DESC').first
       @last_ieee_diag = IeeeDiag.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal DESC').first
       @last_physical = Physical.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal DESC').first
       @last_factor = Factor.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal DESC').first
       @last_furano = Furano.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal DESC').first
       @graphic_furanos = Furano.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal ASC')
       @chromatographical_duval = ChromatographicalDuval.where(transformer_id: params[:id]).first
       #@last_chromatographical_dga_diag = ChromatographicalDgaDiag.where(transformer_id: params[:id]).last
       @last_chromatographical_dga_diag = ChromatographicalDgaDiag.find_by(transformer_id: @transformer.id) 
       @duvals = Duval.all  
    end
 
    # Use callbacks to share common setup or constraints between actions.
    def save_dga_diag_info
      @job_remover2 = IeeeDiag.where("deleted = 1 AND deleted= 2").destroy_all

      @chromatographical_dga_diag = ChromatographicalDgaDiag.where(transformer_id: params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:transformer).permit!
    end
end
