class DevanadoTemplate < ApplicationRecord
  # Model relationships

  has_many   :devanado_template_details
  accepts_nested_attributes_for :devanado_template_details, :allow_destroy => true 

  # Actions using private
  before_save :save_default_values, :if => :new_record?

  # Validate
  validates_uniqueness_of :name, conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El registro se encuentra en uso."
 
  private
    def save_default_values
      self.deleted = 0    
    end 
end 