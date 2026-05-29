class ReportManagement::Step2ReportsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy]

  # GET /mark_management/reports
  # GET /mark_management/reports.json 
  def index
    if user_permission.include?(142)
      @customer = Customer.find(params[:customer_id])
      @list_customers = Customer.where("id = ?",@customer.id)
      @customer_substations = CustomerSubstation.where("deleted=0 AND customer_id = ?", params[:customer_id] )
      @list_transformers = Transformer.includes(:mark, :customer_substation=> [ :customer_area, :customer_area=> [ :customer_location =>[:customer =>[:country] ] ] ] ).where("deleted=0 AND customer_substation_id IN (?)",@customer_substations.map { |e| e.id })
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /mark_management/reports/new
  def new
    if user_permission.include?(142)
      if params[:transformer_id].present?
         @report = Report.new
         @nested_contact = @report.report_details.build
         @customer = Customer.find(params[:customer_id])
         @transformer = Transformer.find(params[:transformer_id])
      else
        @report = Report.new
        #2.times do
          @nested_contact = @report.report_details.build
        #end
        @customer = Customer.find(params[:customer_id])
        @list_customers = Customer.where("id = ?",@customer.id)
        @customer_substations = CustomerSubstation.where("deleted=0 AND customer_id = ?", params[:customer_id] )
        @list_transformers = Transformer.includes(:mark, :customer_substation=> [ :customer_area, :customer_area=> [ :customer_location =>[:customer =>[:country] ] ] ] ).where("deleted=0 AND customer_substation_id IN (?)",@customer_substations.map { |e| e.id })
      end 
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /mark_management/reports/1
  # GET /mark_management/reports/1.json
  def show
    if user_permission.include?(142)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end
  


  # GET /mark_management/reports/1/edit
  def edit
    if user_permission.include?(142)
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
      flash[:notice] = 'Data creada.'
      flash[:type_message] = 'success'
      redirect_to [:report_management,:reports]
    else
      flash[:notice] = 'Error al crear.'
      flash[:type_message] = 'danger'
      redirect_to [:report_management,:reports]
    end 
  end

  # PATCH/PUT /mark_management/reports/1
  # PATCH/PUT /mark_management/reports/1.json
  def update
    if @report.update(model_params)
      flash[:notice] = 'Data actualizada.'
      flash[:type_message] = 'success'
      redirect_to [:report_management, @report]    
    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      render :edit
    end
  end

  # DELETE /mark_management/reports/1
  # DELETE /mark_management/reports/1.json  
  def destroy
    if user_permission.include?(142)
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
