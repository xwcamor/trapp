class PhysicalManagement::PostsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:edit,:update]
  before_action :set_model_menu, only: [ :new]
  before_action :set_select, only: [ :new ,:edit]

 
  # GET /physical_management/posts
  # GET /physical_management/posts.json 
  def index
    if user_permission.include?(39)
     @transformer = Transformer.find(params[:transformer_id])
     @posts = PhysicalPost.where("transformer_id = ?",@transformer.id)

    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /physical_management/posts/1
  # GET /physical_management/posts/1.json
  def show
    if user_permission.include?(40)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /physical_management/posts/new
  def new
    if user_permission.include?(41)
      @post = PhysicalPost.new
       
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /physical_management/posts/1/edit
  def edit
    if user_permission.include?(42)
      @post = PhysicalPost.find(params[:id])
      @physical = Physical.find(@post.physical_id )
      @list_comments = Comment.where("post_id = ?",@post.id)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /physical_management/posts
  # POST /physical_management/posts.json
  def create
    @post = PhysicalPost.new(model_params)
    if @post.save
      flash[:notice] = 'Se Guardò el Comentario.'
      flash[:type_message] = 'success'
      redirect_to physical_management_transformer_physicals_path(@post.physical.transformer_id)
    else
      flash[:notice] = 'Error al guardar el comentatio.'
      flash[:type_message] = 'danger'
      redirect_to physical_management_transformer_physicals_path(@post.physical.transformer_id)
    end 
  end

  # PATCH/PUT /physical_management/posts/1
  # PATCH/PUT /physical_management/posts/1.json
  def update
    if @post.update(model_params)
      flash[:notice] = 'Se Actualizó el Comentario.'
      flash[:type_message] = 'success'
      redirect_to physical_management_transformer_physicals_path(@post.physical.transformer_id)
    else
      flash[:notice] = 'Error al guardar el comentatio.'
      flash[:type_message] = 'danger'
      redirect_to physical_management_transformer_physicals_path(@post.physical.transformer_id)
    end
  end

  # DELETE /physical_management/posts/1
  # DELETE /physical_management/posts/1.json  
  def destroy
    if user_permission.include?(43)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @post = PhysicalPost.find(params[:id] )
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_model_menu
      @physical = Physical.find(params[:physical_id] )
    end
 
    # Use callbacks to share common setup or constraints between actions.
    def set_select
      @type_comments = TypeComment.where("option_post_id = 2 AND deleted = 0")
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:physical_post).permit!
    end
end