class JsonManagement::AdminAuditsController < ApplicationController
 
  # GET /json_management/audits
  # GET /json_management/audits.json 
  def index
      @list_audits = Audit.includes(:user) 
  end

end 