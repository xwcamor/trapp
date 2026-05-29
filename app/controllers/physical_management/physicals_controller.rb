class PhysicalManagement::PhysicalsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy ]
  before_action :set_transformer, only: [:index, :search, :show, :new , :edit, :delete, :detroy]
  before_action :set_model_new, only: [:new] 
  before_action :last_physical, only: [:index, :search ]

  # GET/POST /physical_management/physicals/search
  def search
    if user_permission.include?(48)
      index
      render :index
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end     
  end

  # GET /physical_management/physicals
  # GET /physical_management/physicals.json 
  def index
    if user_permission.include?(48)
      @posts = Post.where("transformer_id = ?",params[:transformer_id])
      @physical_posts = PhysicalPost.where("transformer_id = ?",params[:transformer_id])
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /physical_management/physicals/1
  # GET /physical_management/physicals/1.json
  def show
    if user_permission.include?(49)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /physical_management/physicals/new
  def new
    if user_permission.include?(50)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /physical_management/physicals/1/edit
  def edit
    if user_permission.include?(51)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /physical_management/physicals
  # POST /physical_management/physicals.json
  def create
    @physical = Physical.new(model_params)
    if @physical.save
      flash[:notice] = 'Se guardaron los datos del Análisis Físico Químico.'
      flash[:type_message] = 'success'
      redirect_to physical_management_transformer_physicals_path(@physical.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Análisis Físico Químico, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to new_physical_management_transformer_physical_path(@physical.transformer_id)
    end 
  end

  # PATCH/PUT /physical_management/physicals/1
  # PATCH/PUT /physical_management/physicals/1.json
  def update
    if @physical.update(model_params)
      flash[:notice] = 'Se guardaron los datos del Análisis Físico Químico.'
      flash[:type_message] = 'success'
      redirect_to physical_management_transformer_physicals_path(@physical.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Análisis Físico Químico, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to edit_physical_management_transformer_physical_path(@physical.transformer_id, @physical)
    end
  end

  # GET /physical_management/physicals/1/delete
  def delete
    if user_permission.include?(52)
      @physical = Physical.find(params[:physical_id])
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # DELETE /physical_management/physicals/1
  # DELETE /physical_management/physicals/1.json  
  def destroy
    if user_permission.include?(52)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transformer
      @transformer = Transformer.find(params[:transformer_id] )
      @list_physicals = Physical.where("deleted=0 AND transformer_id = ?",@transformer.id).order("date_rehearsal DESC")
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @physical = Physical.find(params[:id] )
    end
       
    # Use callbacks to share common setup or constraints between actions.
    def set_model_new
      @physical = Physical.new
    end 

    # Use callbacks to share common setup or constraints between actions.
    def last_physical
      @last_physical = Physical.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal ASC').last      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:physical).permit!
    end
end