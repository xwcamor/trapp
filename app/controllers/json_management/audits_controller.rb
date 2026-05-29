class JsonManagement::AuditsController < ApplicationController
 
  # GET /json_management/audits
  # GET /json_management/audits.json 
  def index
      @list_audits = Audit.includes(:user).where("user_id= ?",current_user.id)
  end

end 