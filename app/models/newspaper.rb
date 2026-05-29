class Newspaper < ApplicationRecord
  # Model relationships
  belongs_to :user
  
  # Actions using private
  before_save :save_default_values, :if => :new_record?

  # Method string on action show
  def str_state
    return "Activo" if state == 0
    return "Inactivo" if state == 1
  end

 
  # Private Values
  private
    def save_default_values
      self.deleted = 0    
    end 
end 
