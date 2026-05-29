class Customer < ApplicationRecord
  # Model relationships
  belongs_to :country 
  has_many :customer_locations 
  mount_uploader :avatar, CustomerUploader

  audited
  has_associated_audits
  
  # Actions using private
  before_save :save_default_values, :if => :new_record?

  # Validate
  validates_uniqueness_of :name,   conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El registro se encuentra en uso."
  validates_uniqueness_of :num_doc, conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El registro se encuentra en uso."
  
  def str_country_customer
    self.country.short_name.to_s + " - " + self.name.to_s
  end 

  def str_count_locations
    CustomerLocation.where("deleted = 0 AND customer_id= ? ",self.id ).size
  end 

  def str_count_areas
    CustomerArea.where("deleted = 0 AND customer_id= ? ",self.id ).size
  end 

  def str_count_substations
    CustomerSubstation.where("deleted = 0 AND customer_id= ? ",self.id ).size
  end 

  def str_count_transformers
    #@cs= CustomerSubstation.where("deleted = 0 AND customer_id= ? ",self.id )
    @transformer_count= Transformer.where("deleted = 0 AND customer_substation_id IN (select id from customer_substations where deleted=0 AND customer_id = #{self.id} )").size
    return @transformer_count
  end 

  def country_short_name
    self.country.short_name.downcase
  end 

  # Pagination = 10
  self.per_page = 10

  # Private Values
  private
    def save_default_values
      self.db_system_id = 1
      self.deleted = 0    
    end 
end 