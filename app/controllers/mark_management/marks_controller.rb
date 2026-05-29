class MarkManagement::MarksController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy]

  # GET /mark_management/marks
  # GET /mark_management/marks.json 
  def index
    if user_permission.include?(72)
      @marks = Mark.where(deleted: 0)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /mark_management/marks/new
  def new
    if user_permission.include?(73)
      @mark = Mark.new
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /mark_management/marks/1
  # GET /mark_management/marks/1.json
  def show
    if user_permission.include?(74)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end
  


  # GET /mark_management/marks/1/edit
  def edit
    if user_permission.include?(75)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /mark_management/marks
  # POST /mark_management/marks.json
  def create
    @mark = Mark.new(model_params)
    if @mark.save
      flash[:notice] = 'Data creada.'
      flash[:type_message] = 'success'
      redirect_to [:mark_management,:marks]
    else
      flash[:notice] = 'Error al crear.'
      flash[:type_message] = 'danger'
      render :new
    end 
  end

  # PATCH/PUT /mark_management/marks/1
  # PATCH/PUT /mark_management/marks/1.json
  def update
    if @mark.update(model_params)
      flash[:notice] = 'Data actualizada.'
      flash[:type_message] = 'success'
      redirect_to [:mark_management, @mark]    
    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      render :edit
    end
  end

  # DELETE /mark_management/marks/1
  # DELETE /mark_management/marks/1.json  
  def destroy
    if user_permission.include?(76)
      @mark.update_attribute(:deleted,1)
      flash[:notice] = 'Data eliminada'
      flash[:type_message] = 'success'
      redirect_to [:mark_management,:marks]
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @mark = Mark.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:mark).permit!
    end
end
