class NotificationManagement::AdminUserNotificationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy]

 
  # GET /notification_management/user_notifications
  # GET /notification_management/user_notifications.json 
  def index
    if user_permission.include?(117)
      @user_notifications = UserNotification.where(deleted: 0) 
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /notification_management/user_notifications/new
  def new
    if user_permission.include?(118)
      @user_notification = UserNotification.new
      @transformers = Transformer.where('deleted = 0')
      @users = User.where('deleted = 0 and state =0')
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /notification_management/user_notifications/1
  # GET /notification_management/user_notifications/1.json
  def show
    if user_permission.include?(119)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end
  


  # GET /notification_management/user_notifications/1/edit
  def edit
    if user_permission.include?(120)
      @transformers = Transformer.where('deleted = 0')
      @users = User.where('deleted = 0 and state =0')
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /notification_management/user_notifications
  # POST /notification_management/user_notifications.json
  def create
    @user_notification = UserNotification.new(model_params)
     
    if @user_notification.save
      flash[:notice] = 'Data creada.'
      flash[:type_message] = 'success'
      redirect_to [:notification_management,:admin_user_notifications]
    else
      flash[:notice] = 'Error al crear.'
      flash[:type_message] = 'danger'
      render :new
    end 
  end

  # PATCH/PUT /notification_management/user_notifications/1
  # PATCH/PUT /notification_management/user_notifications/1.json
  def update
    if @user_notification.update(model_params)
      flash[:notice] = 'Data actualizada.'
      flash[:type_message] = 'success'
      redirect_to [:notification_management, :user_notifications]    
    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      render :edit
    end
  end

  # DELETE /notification_management/user_notifications/1
  # DELETE /notification_management/user_notifications/1.json  
  def destroy
    if user_permission.include?(121)
      @admin_user_notification.update_attribute(:deleted,1)
      flash[:notice] = 'Data eliminada'
      flash[:type_message] = 'success'
      redirect_to [:notification_management,:admin_user_notifications]
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @admin_user_notification = UserNotification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:user_notification).permit!
    end
end
