class UserManagement::AuthenticationsController < ApplicationController
  layout "login_v3", :only => [:new,:create,:forgot_password,:account_settings, :set_account_info,:password_reset,:send_password_reset_instructions,:new_password]
  #layout "application", :only => [:index ]
  before_action :authenticate_user, :only => [:index ]
 
  def search
    index
    render :index
  end

  ############# Index de usuario
  def index

    @user_customers = UserCustomer.where('user_id IN (?)',current_user.id)
    @condicion = UserCustomer.where('user_id=?',current_user.id).length 

    # Ransack search params
    @search_customer = params[:search_customer]
  
    # Ransack search
    @query = Transformer.ransack(params[:q])

    # Ransack conditions
    @query.deleted_eq = 0
    @query.customer_substation_customer_id_in =  @user_customers.pluck(:customer_id)    if @search_customer.nil? or @search_customer.to_i == 0
    @query.customer_substation_customer_id_eq =  @search_customer if @search_customer.to_i > 0
    @results =  @query.result(distinct: true) 
    
    # Final result
    @registry_trafos = @results

  end

  ############# NUEVA SESION

  def new
    @user = User.new
  end

  def create      
    @user = User.authenticate(params[:user][:username], params[:user][:password])
    if @user
      update_authentication_token(@user, params[:user][:remember_me])
      @user.last_signed_in_on = DateTime.now
      @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'Se ingresó correctamente al sistema.'
      flash[:type_message] = 'success'
      redirect_to controller: "user_management/authentications" , action: "index"
    else
      flash[:type_message] = 'danger' 
      flash[:notice] = "Usuario o contraseña incorrecto."
      redirect_to :root
    end
  end

  ############# Ver SESION
  def show
    if user_permission.include?(1)
      @user = User.find(session[:user_id])
    else
      flash[:notice] = 'Por favor logearse al sistema.'
      flash[:type_message] = 'danger'      
      redirect_to :root
    end    
  end

  ############ CERRAR SESION
  def signed_out
    user = User.find_by_id(session[:user_id])
    if user
      update_authentication_token(user, nil)
      user.save
      session[:user_id] = nil
      redirect_to :root
    else
      redirect_to controller: "user_management/authentications" , action: "index"
    end
  end
 
  #####################################
  def set_account_info
    old_user = current_user

    # verify the current password by creating a new user record.
    @user = User.authenticate_by_username(old_user.username, params[:user][:password])

    # verify
    if @user.nil?
      @user = old_user
      @user.errors[:password] = "Contraseña incorrecta."
      render :action => "account_settings"
    else
      # update the user with any new username and email
      @user.update(params[:user])
      # Set the old email and username, which is validated only if it has changed.
      @user.previous_email = old_user.email
      @user.previous_username = old_user.username

      if @user.valid?
        # If there is a new_password value, then we need to update the password.
        @user.password = @user.new_password unless @user.new_password.nil? || @user.new_password.empty?
        @user.save
        flash[:notice] = 'Información actualizada.'
        redirect_to :root
      else
        render :action => "account_settings"
      end
    end
  end

###### OLVIDO SU CONTRASEÑA

  def forgot_password
    @user = User.new
  end

  def send_password_reset_instructions
    username_or_email = params[:user][:username]
    if username_or_email.rindex('@')
      @user = User.find_by_email(username_or_email)
    else
      @user = User.find_by_username(username_or_email)
    end

    if @user
      @user.password_reset_token = SecureRandom.urlsafe_base64
      @user.password_expires_after = 24.hours.from_now
      @user.password_reset_token_date = DateTime.now
      @user.save
      UserManagement::UserMailers.reset_password_email(@user).deliver

      flash[:type_message] = 'success'     
      flash[:notice] = 'Las instrucciones se enviaron a su email.'
      redirect_to :root
    else
      @user = User.new
      @user.username = params[:user][:username]
      
      flash[:type_message] = 'danger' 
      flash[:notice] = 'El usuario o cuenta no se encuentra en la base de datos.'
      render :action => "forgot_password"
    end
  end


############# CAMBIO DE CONTRASEÑA
  
  def password_reset
    token = params[:token]
    @user = User.find_by_password_reset_token(token)

    if @user.nil?
      flash[:type_message] = 'danger'  
      flash[:notice] = 'No se encontró el usuario para resetear email'
      redirect_to :root
      return
    end

    if @user.password_expires_after < DateTime.now
      clear_password_reset(@user)
      @user.save

      flash[:type_message] = 'danger'  
      flash[:notice] = 'El link de cambio de contraseña ya expiró, por favor realizar click en Olvidó Contraseña.'
      redirect_to :forgot_password
    end
  end

  def new_password
    username = params[:user][:username]
    @user = User.find_by_username(username)

    if verify_new_password(params[:user])
      @user.update(user_params)
      @user.password = @user.new_password

      if @user.valid?
        clear_password_reset(@user)
        @user.password_reset_change_date = DateTime.now
        @user.save
        UserManagement::UserMailers.changed_password(@user).deliver

        flash[:type_message] = 'success'
        flash[:notice] = 'Se cambió la contraseña correctamente.'
        redirect_to :root
      else
        flash[:type_message] = 'danger'
        flash[:notice] = 'Ocurrió un error, por favor abra nuevamente el link de cambio de contraseña.'
        redirect_to :root
      end
    else
      flash[:type_message] = 'danger'
      flash[:notice] = 'La contraseña no puede ir en blanco.'
      redirect_to :root
    end
  end

########### FUNCIONES PRIVADAS

  private

##################################

  def clear_password_reset(user)
    user.password_expires_after = nil
    user.password_reset_token = nil
  end

#################################

  def verify_new_password(passwords)
    result = true

    if passwords[:new_password].blank? || (passwords[:new_password] != passwords[:new_password_confirmation])
      result=false
    end

    result
  end

#################################

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

#################################

  def user_params
    params.require(:user).permit!
  end

end