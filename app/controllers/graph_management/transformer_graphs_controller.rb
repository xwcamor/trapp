class GraphManagement::TransformerGraphsController < ApplicationController
  before_action :authenticate_user
  before_action :set_model, only: [:show, :edit, :update ]

  # GET /graph_management/transformer_graphs
  # GET /graph_management/transformer_graphs.json 
  def index
    if user_permission.include?(72)
      @transformer_graphs = TransformerGraph.all
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /graph_management/transformer_graphs/new
  def new
    if user_permission.include?(73)
      @transformer_graph = TransformerGraph.new
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /graph_management/transformer_graphs/1
  # GET /graph_management/transformer_graphs/1.json
  def show
    if user_permission.include?(74)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end
  


  # GET /graph_management/transformer_graphs/1/edit
  def edit
    if user_permission.include?(75)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /graph_management/transformer_graphs
  # POST /graph_management/transformer_graphs.json
  def create
    @transformer_graph = TransformerGraph.new(model_params)
    if @transformer_graph.save
      flash[:notice] = 'Data creada.'
      flash[:type_message] = 'success'
      redirect_to [:graph_management,:transformer_graphs]
    else
      flash[:notice] = 'Error al crear.'
      flash[:type_message] = 'danger'
      render :new
    end 
  end

  # PATCH/PUT /graph_management/transformer_graphs/1
  # PATCH/PUT /graph_management/transformer_graphs/1.json
  def update
    if @transformer_graph.update(model_params)
      flash[:notice] = 'Data actualizada.'
      flash[:type_message] = 'success'
      #redirect_to [:graph_management, @transformer_graph]    
      redirect_to [:graph_management,:transformer_graphs]
    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      render :edit
    end
  end

  # DELETE /graph_management/transformer_graphs/1
  # DELETE /graph_management/transformer_graphs/1.json  
  def destroy
    if user_permission.include?(76)
      @transformer_graph.update_attribute(:deleted,1)
      flash[:notice] = 'Data eliminada'
      flash[:type_message] = 'success'
      redirect_to [:graph_management,:transformer_graphs]
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @transformer_graph = TransformerGraph.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:transformer_graph).permit!
    end
end
