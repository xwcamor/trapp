class UserManagement::AccessesController < ApplicationController
  before_action :authenticate_user
 
  # GET /user_management/accesses
  # GET /user_management/accesses.json
  def index
    if user_permission.include?(15)
      @accesses = Access.where(parent_id: 0)
    else
      flash[:notice] = "Sorry, you don't have access. Please contact to your administrator."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /user_management/accesses/new
  def new  
    if user_permission.include?(16)
      @access = Access.new
    else
      flash[:notice] = "Sorry, you don't have access. Please contact to your administrator."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # POST /user_management/accesses
  # POST /user_management/accesses.json
  def create
    @access = Access.new(access_params)
    if @access.save
      flash[:notice] = 'Data created'
      flash[:type_message] = 'success'
      redirect_to :controller=>"user_management/grants",:action=>"new",:parent_id=>@access.id
    else
      flash[:notice] = 'Ocurrió un error al momento de registrar el acceso'
      flash[:type_message] = 'danger'
      render :new
    end
  end

  # GET /user_management/accesses/1
  # GET /user_management/accesses/1.json
  def show
    if user_permission.include?(17)
      @access = Access.find(params[:id])
      @grants = Access.where('parent_id = ?',params[:id]).paginate(:page => params[:page] ).order('name ASC')
    else
      flash[:notice] = "Sorry, you don't have access. Please contact to your administrator."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /user_management/accesses/1/edit
  def edit
    if user_permission.include?(18)
      @access = Access.find(params[:id]) 
    else
      flash[:notice] = "Sorry, you don't have access. Please contact to your administrator."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # PATCH/PUT /user_management/accesses/1
  # PATCH/PUT /user_management/accesses/1.json 
  def update
    @access = Access.find(params[:id])
    if @access.update(access_params)
      flash[:notice] = 'Data updated.'
      flash[:type_message] = 'success'
      redirect_to [:user_management, @access]
    else
      flash[:notice] = 'Issue on update.'
      flash[:type_message] = 'danger'
      render :edit
    end
  end
  
  # DELETE /user_management/accesses/1
  # DELETE /user_management/accesses/1.json
  def destroy
    if user_permission.include?(19)
      @access = Access.find(params[:id])
      @grants = Access.where(parent_id: params[:id])
      @grants.each do |grant|
        grant.destroy
      end
      @access.destroy      
      flash[:notice] = 'Data deleted.'
      flash[:type_message] = 'success'
      redirect_to [:user_management,:accesses]
    else
      flash[:notice] = "Sorry, you don't have access. Please contact to your administrator."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def access_params
       params.require(:access).permit!
    end
end