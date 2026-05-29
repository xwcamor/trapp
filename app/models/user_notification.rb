class UserNotification < ActiveRecord::Base
  # Model relationships	
  belongs_to :user
  belongs_to :transformer

  # Actions using private
  before_save :save_default_values, :if => :new_record?

  # Method string on action show
  def str_state
    return "Activo" if state == 0
    return "Inactivo" if state == 1
  end

  # Method string on action show
  def str_date_notification
    self.date_notification.strftime("%d-%m-%Y")
  end
  # Validate
 
  private
    def save_default_values
      self.deleted = 0    
    end 
end
