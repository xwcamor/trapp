class CustomerSubstation < ApplicationRecord
  # Model relationships
  belongs_to :customer_area
  belongs_to :customer
  has_many :transformers

  audited associated_with: :customer
  
  # Actions using private
  before_save :save_default_values, :if => :new_record?

  # Validate
  validates_uniqueness_of :name, :scope => :customer_id, :scope => :customer_area_id, conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El registro se encuentra en uso."

  # Pagination = 10
  self.per_page = 10
 
  private
    def save_default_values
      self.deleted = 0    
    end 
end 