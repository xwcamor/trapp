class MeetingManagement::AdminCalendarMeetingsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy]

 
  # GET /meeting_management/admin_meetings
  # GET /meeting_management/admin_meetings.json 
  def index
    if user_permission.include?(86)
      @admin_meetings = Meeting.where(deleted: 0) 
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /meeting_management/admin_meetings/new
  def new
    if user_permission.include?(87)
      @admin_meeting = Meeting.new
      #@transformers = Transformer.where('deleted = 0')
      @users = User.where('deleted = 0 and state =0')
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /meeting_management/admin_meetings/1
  # GET /meeting_management/admin_meetings/1.json
  def show
    if user_permission.include?(88)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end
  


  # GET /meeting_management/admin_meetings/1/edit
  def edit
    if user_permission.include?(89)
      #@transformers = Transformer.where('deleted = 0')
      @users = User.where('deleted = 0 and state =0')
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /meeting_management/admin_meetings
  # POST /meeting_management/admin_meetings.json
  def create
    @admin_meeting = Meeting.new(model_params)
     
    if @admin_meeting.save
      flash[:notice] = 'Data creada.'
      flash[:type_message] = 'success'
      redirect_to [:meeting_management,:admin_meetings]
    else
      flash[:notice] = 'Error al crear.'
      flash[:type_message] = 'danger'
      render :new
    end 
  end

  # PATCH/PUT /meeting_management/admin_meetings/1
  # PATCH/PUT /meeting_management/admin_meetings/1.json
  def update
    if @admin_meeting.update(model_params)
      flash[:notice] = 'Data actualizada.'
      flash[:type_message] = 'success'
      redirect_to meeting_management_admin_meetings_path    
    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      render :edit
    end
  end

  # DELETE /meeting_management/admin_meetings/1
  # DELETE /meeting_management/admin_meetings/1.json  
  def destroy
    if user_permission.include?(90)
      @admin_meeting.update_attribute(:deleted,1)
      flash[:notice] = 'Data eliminada'
      flash[:type_message] = 'success'
      redirect_to [:meeting_management,:admin_meetings]
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @admin_meeting = Meeting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:meeting).permit!
    end
end
