class AuditManagement::AuditsController < ApplicationController
  before_action :authenticate_user
  
  def index
    if user_permission.include?(147)
      @audits = Audit.where("user_id = ? ",current_user.id)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end  	
  end
end