class CalendarManagement::MeetEventsController < ApplicationController
  before_action :authenticate_user
  before_action :set_course_event, only: [:show, :edit, :update, :destroy]
 

  def index
    @course_events = MeetEvent.where(start: params[:start]..params[:end],deleted: 0)
  end

  def show
  end

  def new
    @course_event = MeetEvent.new
    @transformers = Transformer.where('deleted = 0').order('num_serie')
  end

  def edit
     @transformers = Transformer.where('deleted = 0').order('num_serie')
  end

  def create
    @course_event = MeetEvent.new(course_event_params)
    @course_event.save
    redirect_to [:calendar_management, :course_schedules]

  end

  def update
    @course_event.update(course_event_params)
    redirect_to [:calendar_management, :course_schedules]
  end

  def destroy
    @course_event.update_attribute(:deleted,1)
    redirect_to [:calendar_management, :course_schedules]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_event
      @course_event = MeetEvent.find(params[:id])
    end

    def set_teachers
      @transformers = Transformer.where('deleted = 0').order('num_serie')
    end

    def set_courses
     # @courses = Course.where('deleted = 0').order('name ASC')
    end

    def set_place_details
      #@place_details = PlaceDetail.where('deleted = 0').order('name ASC')
    end            

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_event_params
      params.require(:meet_event).permit!
    end

end
