class NewspaperManagement::AdminNewspapersController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy]

  # GET /newspaper_management/admin_newspapers
  # GET /newspaper_management/admin_newspapers.json 
  def index
    if user_permission.include?(106)
      @admin_newspapers = Newspaper.where(deleted: 0)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /newspaper_management/admin_newspapers/new
  def new
    if user_permission.include?(107)
      @admin_newspaper = Newspaper.new
      @users = User.where("state = 0 AND deleted= 0")
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /newspaper_management/admin_newspapers/1
  # GET /newspaper_management/admin_newspapers/1.json
  def show
    if user_permission.include?(108)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end
  


  # GET /newspaper_management/admin_newspapers/1/edit
  def edit
    if user_permission.include?(109)
       @users = User.where("state = 0 AND deleted= 0")
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /newspaper_management/admin_newspapers
  # POST /newspaper_management/admin_newspapers.json
  def create
    @admin_newspaper = Newspaper.new(model_params)
    if @admin_newspaper.save
      flash[:notice] = 'Data creada.'
      flash[:type_message] = 'success'
      redirect_to [:newspaper_management,:admin_newspapers]
    else
      flash[:notice] = 'Error al crear.'
      flash[:type_message] = 'danger'
      render new_newspaper_management_admin_newspaper_path
    end 
  end

  # PATCH/PUT /newspaper_management/admin_newspapers/1
  # PATCH/PUT /newspaper_management/admin_newspapers/1.json
  def update
    if @admin_newspaper.update(model_params)
      flash[:notice] = 'Data actualizada.'
      flash[:type_message] = 'success'
      redirect_to newspaper_management_admin_newspapers_path    
    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      render edit_newspaper_management_admin_newspaper_path(@admin_newspaper)
    end
  end

  # DELETE /newspaper_management/admin_newspapers/1
  # DELETE /newspaper_management/admin_newspapers/1.json  
  def destroy
    if user_permission.include?(110)
      @admin_newspaper.update_attribute(:deleted,1)
      flash[:notice] = 'Data eliminada'
      flash[:type_message] = 'success'
      redirect_to [:newspaper_management,:admin_newspapers]
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @admin_newspaper = Newspaper.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:newspaper).permit!
    end
end
