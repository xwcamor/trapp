class ApplicationController < ActionController::Base
  before_action :set_permission 
  before_action :set_locale

  #helper :all
  helper_method :current_user
  helper_method :user_permission
  helper_method :amchart_license
  helper_method :main_notifications
  protect_from_forgery


  def current_user
    # Note: we want to use "find_by_id" because it's OK to return a nil.
    # If we were to use User.find, it would throw an exception if the user can't be found.
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    @current_user ||= User.find_by_authentication_token(cookies[:auth_token]) if cookies[:auth_token] && @current_user.nil?
    @current_user
  end

  def main_notifications
    @main_notifications =  UserNotification.where(deleted: 0,state: 0,user_id:session[:user_id] ) 
  end
  
  # truco para guardar la IP
  def record_activity(note)
      @activity = ActivityLog.new
      @activity.user_id = current_user.id
      @activity.note = note
      @activity.browser = request.env['HTTP_USER_AGENT']
      @activity.ip_address = request.env['REMOTE_ADDR']
      @activity.controller = controller_name 
      @activity.action = action_name 
      @activity.params = params.inspect.to_s
      @activity.save
  end

  def user_permission
    profile = Profile.select("profile_accesses.access_id").joins(:profile_accesses).where("profiles.id= ?", current_user.profile_id )
    #puts "Mostrando todos los accesos del perfil que usa el usuario....."
    return profile.map { |e| e.access_id }
  end
  
#################################################
  private
 
  def set_locale
    I18n.locale = :es
  end
 
  def authorize
    unless User.find_by_id(session[:user_id])
      session[:original_uri] = request.url
      flash[:notice] = "Please login2"
      redirect_to :root
    end
  end

  def authenticate_user
    if current_user.nil?
      flash[:error] = 'Por favor logeate.'
      redirect_to :root
    end
  end

##################################################

  def get_extension(file)
    begin
      file_name = file['datafile'].original_filename
      parse_val = file_name.split(".")
      extension = parse_val[parse_val.length-1].downcase
    rescue
      extension = ""
    end
    return extension
  end

 # Errores
  def get_errors(object)
    str_error = ""
    object.errors.each do |attr, message|
      str_error = str_error + message + "<br/>"
    end
    return str_error
  end

  # AMCHART LICENSE
  def amchart_license
    @amchart_license = Rails.application.credentials.dig(:licences, :amchart)
    return @amchart_license
  end

  # CREATE VALUE TO USE ON VIEWS
  def set_permission
    if current_user.present?
      @user_permission = user_permission
      #puts "Generando variable global de permisos para ser usado en las vistas....."
    end
  end
   

end
