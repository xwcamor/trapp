class ReportManagement::TransformerReportsController < ApplicationController
  before_action :authenticate_user 
  before_action :set_model, only: [:show, :edit, :update, :destroy]
  layout "report", only: [:show]

  # GET /mark_management/reports
  # GET /mark_management/reports.json 
  def upload_customer_file
    if User.authentication(session[:user_id],158)
      @report = Report.find(params[:report_id])
    
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /mark_management/reports
  # GET /mark_management/reports.json 
  def index
    if User.authentication(session[:user_id],157)
      @report_details = ReportDetail.where("transformer_id = ?",params[:transformer_id] )
      @reports = Report.where("id IN (?)",@report_details.map { |e| e.report_id })

    
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /mark_management/reports/new
  def new
    if User.authentication(session[:user_id],142)
      @report = Report.new
      #2.times do
      #  @nested_contact = @report.report_details.build
      #end
      @list_user_customers = UserCustomer.joins(:customer).where('user_customers.user_id=?',current_user.id).order("customers.country_id DESC, customers.name")
      #@customer_substations = CustomerSubstation.where("deleted=0 AND customer_id IN (?)",@user_customers.map { |e| e.customer_id })
      #@condicion = UserCustomer.where('user_id=?',current_user).length 
      #@list_transformers = Transformer.includes(:mark, :customer_substation=> [ :customer_area, :customer_area=> [ :customer_location =>[:customer =>[:country] ] ] ] ).where("deleted=0 AND customer_substation_id IN (?)",@customer_substations.map { |e| e.id })
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /mark_management/reports/1
  # GET /mark_management/reports/1.json
  def show
    
    if User.authentication(session[:user_id],143)
      #@report.create_sheets
      
      respond_to do |format|
        format.html
        format.xlsx
        format.doc  

        format.pdf  { 
          render :pdf => "PGTR-IS-23 - #{@report.customer.name} - Reporte análisis dieléctrico",
          :layout => "pdf",
          #wkhtmltopdf: '/usr/local/bin/wkhtmltopdf',
          show_as_html:                   params.key?('debug'), 
          #:footer => "pdf_footer",
          #footer: { right: '[page] of [topage]'} ,
          header:  {   html: {   layout:'layouts/pdf_footer'}},

          footer: {:layout=> 'pdf_footer',
                            #right:             '14',
                            spacing:           1,
                            line:              true,
           },
          :orientation => 'Portrait',:page_size => 'A4'   
        }  

      end          
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end
  


  # GET /mark_management/reports/1/edit
  def edit
    if User.authentication(session[:user_id],144)
      @report_details = ReportDetail.where("report_id = ?",@report.id)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /mark_management/reports
  # POST /mark_management/reports.json
  def create

    @report = Report.new(model_params)
 
    if @report.save
      @customer_substations = CustomerSubstation.where("deleted=0 AND customer_id = ?", @report.customer_id )
      @list_transformers = Transformer.includes(:mark, :customer_substation=> [ :customer_area, :customer_area=> [ :customer_location =>[:customer =>[:country] ] ] ] ).where("deleted=0 AND customer_substation_id IN (?)",@customer_substations.map { |e| e.id })    

      @list_transformers.each do |transformer|
        if params["transformer_"+transformer.id.to_s] == "on"
          report_detail = ReportDetail.new
          report_detail.transformer_id = transformer.id
          report_detail.report_id = @report.id
          report_detail.save
        end
      end      
      flash[:notice] = 'Data creada.'
      flash[:type_message] = 'success'
      redirect_to [:report_management,:reports]
    else
      flash[:notice] = 'Error al crear.'
      flash[:type_message] = 'danger'
      render :new
    end 
  end

  # PATCH/PUT /mark_management/reports/1
  # PATCH/PUT /mark_management/reports/1.json
  def update
    if @report.update(model_params)
      flash[:notice] = 'Data actualizada.'
      flash[:type_message] = 'success'
      redirect_to [:report_management, :reports]    
    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      redirect_to [:report_management, :reports]    
    end
  end

  # DELETE /mark_management/reports/1
  # DELETE /mark_management/reports/1.json  
  def destroy
    if User.authentication(session[:user_id],145)
      @report.update_attribute(:deleted,1)
      flash[:notice] = 'Data eliminada'
      flash[:type_message] = 'success'
      redirect_to [:report_management,:reports]
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:report).permit!
    end
end
