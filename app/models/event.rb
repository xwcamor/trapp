class Event < ApplicationRecord
  
  # Model relationships
  belongs_to :transformer
  
  # Actions using private
  before_save :save_default_values, :if => :new_record?
  
  # Validate
  #validates :description, presence: true

  validates :title, presence: true
  attr_accessor :date_range

  def all_day_event?
    self.start == self.start.midnight && self.end == self.end.midnight ? true : false
  end

    
  #################################################

  def str_start
    return start.strftime("%d-%m-%Y %H:%M")
  end

 ##################################################

  def str_end
    self.end.strftime("%H:%M")
  end

  # Pagination = 10
  self.per_page = 10  

  private
    def save_default_values
      self.deleted = 0    
    end   
end
