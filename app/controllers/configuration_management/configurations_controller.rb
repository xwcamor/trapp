class ConfigurationManagement::ConfigurationsController < ApplicationController
  before_action :authenticate_user	

  # GET /configuraation_management/configuraations
  # GET /configuraation_management/configuraations.json 
  def index
    if user_permission.include?(92)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end


end