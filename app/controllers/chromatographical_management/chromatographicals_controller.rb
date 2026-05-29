class ChromatographicalManagement::ChromatographicalsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update, :destroy ]
  before_action :set_transformer, only: [:index, :search, :show, :new , :edit, :delete, :detroy]
  before_action :set_model_new, only: [:new] 
  before_action :last_chromatographical, only: [:index, :search ]
 
  # GET/POST /chromatographical_management/chromatographicals/search
  def search
    if user_permission.include?(39)
      index
      render :index
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end     
  end

  # GET /chromatographical_management/chromatographicals
  # GET /chromatographical_management/chromatographicals.json 
  def index
    if user_permission.include?(39)
      @cromas = Chromatographical.where("transformer_id = ?",params[:transformer_id])
      @cr_duval = ChromatographicalDuval.where("transformer_id = ?",@transformer.id).last
      if   @cromas.size > 0
        if @cr_duval.triangle_diag_second.nil? # 
           redirect_to edit_chromatographical_management_chromatographical_duval_path(params[:transformer_id])
        end
      end

      @posts = Post.where("transformer_id = ?",params[:transformer_id])
      @physical_posts = PhysicalPost.where("transformer_id = ?",params[:transformer_id])
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /chromatographical_management/chromatographicals/1
  # GET /chromatographical_management/chromatographicals/1.json
  def show
    if user_permission.include?(40)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /chromatographical_management/chromatographicals/new
  def new
    if user_permission.include?(41)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /chromatographical_management/chromatographicals/1/edit
  def edit
    if user_permission.include?(42)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /chromatographical_management/chromatographicals
  # POST /chromatographical_management/chromatographicals.json
  def create
    @chromatographical = Chromatographical.new(model_params)
    if @chromatographical.save
      flash[:notice] = 'Se guardaron los datos del Análisis Cromatografico.'
      flash[:type_message] = 'success'
      redirect_to chromatographical_management_transformer_chromatographicals_path(@chromatographical.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Análisis Cromatografico, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to new_chromatographical_management_transformer_chromatographical_path(@chromatographical.transformer_id )
    end 
  end

  # PATCH/PUT /chromatographical_management/chromatographicals/1
  # PATCH/PUT /chromatographical_management/chromatographicals/1.json
  def update
    if @chromatographical.update(model_params)
      flash[:notice] = 'Se guardaron los datos del Análisis Cromatografico.'
      flash[:type_message] = 'success'
      redirect_to chromatographical_management_transformer_chromatographicals_path(@chromatographical.transformer_id)
    else
      flash[:notice] = 'Error al guardar los datos del Análisis Cromatografico, ya hay 1 registro con la misma fecha.'
      flash[:type_message] = 'danger'
      redirect_to edit_chromatographical_management_transformer_chromatographical_path(@chromatographical.transformer_id, @chromatographical )
    end
  end

  # GET /chromatographical_management/customers/1/delete
  def delete
    if user_permission.include?(43)
      @chromatographical = Chromatographical.find(params[:chromatographical_id])
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # DELETE /chromatographical_management/chromatographicals/1
  # DELETE /chromatographical_management/chromatographicals/1.json  
  def destroy
    if user_permission.include?(43)
      @chromatographical.update_attribute(:deleted,1)
      flash[:notice] = 'Se ha eliminado el ensayo.'
      flash[:type_message] = 'danger'    
      redirect_to chromatographical_management_transformer_chromatographicals_path(@chromatographical.transformer_id )        
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
      @list_chromatographicals = Chromatographical.includes([:transformer]).where("deleted=0 AND transformer_id = ?",@transformer.id).order("date_rehearsal DESC")

      @chromatographical_duval = ChromatographicalDuval.where(transformer_id: @transformer.id).first
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @chromatographical = Chromatographical.find(params[:id] )
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_model_new
      @chromatographical = Chromatographical.new
    end

    # Use callbacks to share common setup or constraints between actions.
    def last_chromatographical
      @last_chromatographical = Chromatographical.where(transformer_id: @transformer.id, deleted: 0).order('date_rehearsal ASC').last
    end
       
    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:chromatographical).permit!
    end
end