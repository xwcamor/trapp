class UserManagement::UsersController < ApplicationController
  before_action :authenticate_user
  before_action :set_model,  only: [:show, :edit, :update, :destroy]
  before_action :set_select, only: [:new, :edit, :create, :update]

  # GET /user_management/users
  # GET /user_management/users.json 
  def index
    if user_permission.include?(2)
      @current_profile = current_user.profile_id
      @profile_countries = ProfileCountry.where("profile_id = ?",@current_profile)   
      @countries = Country.where("deleted= 0 AND id IN (?)",@profile_countries.map { |e| e.country_id })

      @users = User.includes([:country], [:profile]).where('deleted = 0 AND id NOT IN (1) AND country_id IN (?)',@countries.map { |e| e.id })
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /user_management/users/1
  # GET /user_management/users/1.json 
  def show
    if user_permission.include?(4)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /user_management/users/new
  def new  
    if user_permission.include?(3)
      @user = User.new
      @current_profile = current_user.profile_id
      @profile_countries = ProfileCountry.where("profile_id = ?",@current_profile)      

      @countries = Country.where("deleted= 0 AND id IN (?)",@profile_countries.map { |e| e.country_id })
      @customers = Customer.where("deleted= 0 AND country_id IN (?)",@countries.map { |e| e.id })
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /user_management/users/1/edit
  def edit
    if user_permission.include?(5)
      @current_profile = current_user.profile_id
      @profile_countries = ProfileCountry.where("profile_id = ?",@current_profile)      

      @countries = Country.where("deleted= 0 AND id IN (?)",@profile_countries.map { |e| e.country_id })
      @customers = Customer.where("deleted= 0 AND country_id IN (?)",@countries.map { |e| e.id })
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # POST /user_management/users
  # POST /user_management/users.json
  def create
    @user = User.new(model_params)
    if @user.save
      update_authentication_token(@user, nil)
      @user.signed_up_on = DateTime.now
      @user.last_signed_in_on = @user.signed_up_on
      @user.deleted = 0
      @user.save
      UserManagement::UserMailers.welcome_email(@user).deliver_now  #or delive_later

      #  ADD CUStOMERS TO USER ACCESS
      if params[:user][:customer_id].present?
        params[:user][:customer_id].each do |user_customer|
          user_customer = UserCustomer.new( user_id: @user.id, customer_id: user_customer )
          user_customer.save
        end
      end

      flash[:notice] = 'Registro creado.'
      flash[:type_message] = 'success'
      redirect_to [:user_management,:users]
    else
      flash[:notice] = 'Error al crear.'
      flash[:type_message] = 'danger'
      redirect_to new_user_management_user_path 
    end
  end

  # PATCH/PUT /user_management/users/1
  # PATCH/PUT /user_management/users/1.json
  def update
    @customers = Customer.where(deleted: 0)
    @countries = Country.where(deleted: 0)    
    @user = User.find(params[:id])
    if @user.update(model_params)
      if params[:user][:real_password].present?
        UserManagement::UserMailers.changed_password(@user).deliver
      end
      
      if params[:user][:customer_id].present?
        @borrado = UserCustomer.where(user_id: @user.id).destroy_all

        params[:user][:customer_id].each do |customer|
          user_customer = UserCustomer.new( user_id: @user.id, customer_id: customer )
          user_customer.save
          @borrado = UserCustomer.where(customer_id: nil).destroy_all
        end
      end
      flash[:notice] = 'Registro actualizado.'
      flash[:type_message] = 'success'
      redirect_to [:user_management,:users]
    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      redirect_to edit_user_management_user_path(@user.id)
    end
  end
  
  # DELETE /user_management/users/1
  # DELETE /user_management/users/1.json
  def destroy
    if user_permission.include?(6)
      if params[:id].to_i!=1
        if @user.update_attribute(:deleted,1)
          flash[:notice] = "Registro eliminado."
          flash[:type_message] = 'success'
          redirect_to [:user_management,:users]
        else
          flash[:notice] = "Error al eliminar."
          flash[:type_message] = 'danger'
          redirect_to [:user_management,:users]
        end
      else
        flash[:notice] = "No puedes eliminar al administrador principal."
        flash[:type_message] = 'danger'
        redirect_to [:user_management,:users]
      end
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  ####################################################
  def update_authentication_token(user, remember_me)
    if remember_me == 1
      # create an authentication token if the user has clicked on remember me
      auth_token = SecureRandom.urlsafe_base64
      user.authentication_token = auth_token
      cookies.permanent[:auth_token] = auth_token
    else              # nil or 0
      # if not, clear the token, as the user doesn't want to be remembered.
      user.authentication_token = nil
      cookies.permanent[:auth_token] = nil
    end
  end

  # PATCH/PUT /user_management/users/1
  # PATCH/PUT /user_management/users/1.json
  def change_password
    if user_permission.include?(7) 
      @user = User.find(params[:user_id])
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @user = User.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_select
      @profiles = Profile.where('id != 1').order('name ASC')
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:user).permit!
    end
end