class CalendarManagement::MeetSchedulesController < ApplicationController
  before_action :authenticate_user
  
  # GET/POST /calendar_management/course_schedules
  def index
    if user_permission.include?(1)

    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = "red"
      redirect_to [:user_management,:authentications]
    end       	
  end
end
