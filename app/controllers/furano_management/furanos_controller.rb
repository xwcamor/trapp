class FuranoManagement::FuranosController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy ]
  before_action :set_transformer, only: [:index, :search, :show, :new , :edit, :delete, :detroy]
  before_action :set_model_new, only: [:new] 
  before_action :last_furano, only: [:index, :search ]

  # GET/POST /furano_management/furanos/search
  def search
    if user_permission.include?(56)
      index
      render :index
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end     
  end

  # GET /furano_management/furanos
  # GET /furano_management/furanos.json 
  def index
    if user_permission.include?(56)
       
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /furano_management/furanos/1
  # GET /furano_management/furanos/1.json
  def show
    if user_permission.include?(57)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /furano_management/furanos/new
  def new
    if user_permission.include?(58)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /furano_management/furanos/1/edit
  def edit
    if user_permission.include?(59)
     else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /furano_management/furanos
  # POST /furano_management/furanos.json
  def create
    @furano = Furano.new(model_params)
    if @furano.save
      flash[:notice] = 'Se guardaron los datos del Furano.'
      flash[:type_message] = 'success'
      redirect_to furano_management_transformer_furanos_path(@furano.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Furano, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to new_furano_management_transformer_furano_path(@furano.transformer_id)
    end 
  end

  # PATCH/PUT /furano_management/furanos/1
  # PATCH/PUT /furano_management/furanos/1.json
  def update
    if @furano.update(model_params)
      flash[:notice] = 'Se guardaron los datos del Furano.'
      flash[:type_message] = 'success'
      redirect_to furano_management_transformer_furanos_path(@furano.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Furano, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to edit_furano_management_transformer_furano_path(@furano.transformer_id, @furano)
    end 
  end

  # GET /furano_management/furanos/1/delete
  def delete
    if user_permission.include?(60)
      @furano = Furano.find(params[:furano_id])
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # DELETE /furano_management/furanos/1
  # DELETE /furano_management/furanos/1.json  
  def destroy
    if user_permission.include?(60)
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
      @list_furanos = Furano.where("deleted=0 AND transformer_id = ?",@transformer.id).order("date_rehearsal DESC")
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @furano = Furano.find(params[:id] )
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_model_new
      @furano = Furano.new
    end

    def last_furano
      @last_furano = Furano.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal ASC').last
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:furano).permit!
    end
end