class Country < ApplicationRecord
  # Model relationships
  has_many :customers
  
  # Actions using private
  before_save :save_default_values, :if => :new_record?

  # Validate
  validates_uniqueness_of :name, conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El registro se encuentra en uso."
 
 
  # Pagination = 10
  self.per_page = 10

  # Private Values
  private
    def save_default_values
      self.deleted = 0    
    end 
end 
