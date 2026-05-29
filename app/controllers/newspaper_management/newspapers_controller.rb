class NewspaperManagement::NewspapersController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy]

  # GET /newspaper_management/newspapers
  # GET /newspaper_management/newspapers.json 
  def index
    if user_permission.include?(112)
      @newspapers = Newspaper.where("deleted = 0 AND state= 0 AND user_id IN  (0,?) ",current_user.id)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /newspaper_management/newspapers/new
  def new
    if user_permission.include?(113)
      @newspaper = Newspaper.new
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /newspaper_management/newspapers/1
  # GET /newspaper_management/newspapers/1.json
  def show
    if user_permission.include?(114)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end
  


  # GET /newspaper_management/newspapers/1/edit
  def edit
    if user_permission.include?(115)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /newspaper_management/newspapers
  # POST /newspaper_management/newspapers.json
  def create
    @newspaper = Newspaper.new(model_params)
    if @newspaper.save
      flash[:notice] = 'Data creada.'
      flash[:type_message] = 'success'
      redirect_to [:newspaper_management,:newspapers]
    else
      flash[:notice] = 'Error al crear.'
      flash[:type_message] = 'danger'
      render :new
    end 
  end

  # PATCH/PUT /newspaper_management/newspapers/1
  # PATCH/PUT /newspaper_management/newspapers/1.json
  def update
    if @newspaper.update(model_params)
      flash[:notice] = 'Data actualizada.'
      flash[:type_message] = 'success'
      #redirect_to [:newspaper_management, @newspaper]    
    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      render :edit
    end
  end

  # DELETE /newspaper_management/newspapers/1
  # DELETE /newspaper_management/newspapers/1.json  
  def destroy
    if user_permission.include?(116)
      @newspaper.update_attribute(:deleted,1)
      flash[:notice] = 'Data eliminada'
      flash[:type_message] = 'success'
      redirect_to [:newspaper_management,:newspapers]
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @newspaper = Newspaper.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:newspaper).permit!
    end
end
