class Report < ApplicationRecord
  # Model relationships
  belongs_to :user
  belongs_to :customer
  #mount_uploader :avatar, AvatarUploader
  has_many :report_details
  accepts_nested_attributes_for :report_details, :allow_destroy => true
  
  # Actions using private
  before_save :save_default_values, :if => :new_record?
  
  mount_uploader :avatar, ReportUploader
  # Validate
  #validates_uniqueness_of :name, conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El registro se encuentra en uso."
 
  # Method string on action show
  def str_created_at
    self.created_at.strftime("%d-%m-%Y %H:%M:%S")
  end

  def str_created_at_order
    self.created_at.strftime("%Y-%m-%d")
  end
 

  def str_transformers
    report_details
      .joins(:transformer)
      .where( transformers: { deleted: 0 })
      .count
  end


  private
    def save_default_values
      self.deleted = 0    
    end 
end 