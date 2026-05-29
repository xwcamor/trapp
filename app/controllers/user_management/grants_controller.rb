class UserManagement::GrantsController < ApplicationController
  before_action :authenticate_user

  # GET /user_management/grants/new?parent_id=1
  def new  
    if user_permission.include?(20)
      @grant = Access.new
      @obj_grant =Access.find(params[:parent_id])
    else
      flash[:notice] = "Sorry, you don't have access. Please contact to your administrator."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # POST /user_management/accesses
  # POST /user_management/accesses.json
  def create
    @grant = Access.new(access_params)
    @obj_grant =Access.find(params[:access][:parent_id])
    if @grant.save
      flash[:notice] = 'Data created'
      flash[:type_message] = 'success'
      redirect_to :controller=>"user_management/accesses",:action=>"show",:id=>@grant.parent_id
    else
      flash[:notice] = 'Issue on create.'
      flash[:type_message] = 'danger'
      render :new
    end
  end
  
  # GET /user_management/grants/access_id/edit?parent_id=1
  def edit
    if user_permission.include?(21)
      @grant = Access.find(params[:id])
    else
      flash[:notice] = "Sorry, you don't have access. Please contact to your administrator."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  # PATCH/PUT /user_management/accesses/1
  # PATCH/PUT /user_management/accesses/1.json   
  def update
    @grant = Access.find(params[:id])
    if @grant.update(access_params)
      flash[:notice] = 'Data updated.'
      flash[:type_message] = 'success'
      redirect_to :controller=>"user_management/accesses",:action=>"show",:id=>@grant.parent_id
    else
      flash[:notice] = 'Issue on update.'
      flash[:type_message] = 'danger'
      render :edit
    end
  end

  # DELETE /user_management/accesses/1
  # DELETE /user_management/accesses/1.json
  def destroy
    if user_permission.include?(22)
      @grant = Access.find(params[:id])
      @grant.destroy
      flash[:notice] = 'Data deleted.'
      flash[:type_message] = 'success'    
      redirect_to :controller=>"user_management/accesses",:action=>"show",:id=>@grant.parent_id
    else
      flash[:notice] = "Sorry, you don't have access. Please contact to your administrator."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def access_params
       params.require(:access).permit(:name, :parent_id )
    end  
end