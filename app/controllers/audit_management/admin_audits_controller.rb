class AuditManagement::AdminAuditsController < ApplicationController
  before_action :authenticate_user
  
  def index
    if user_permission.include?(155)
      @audits = Audit.all 
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end  	
  end
end