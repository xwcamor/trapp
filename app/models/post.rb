class Post < ApplicationRecord
  # Model relationships
  belongs_to :transformer
  belongs_to :chromatographical
  belongs_to :user
  belongs_to :type_comment

  has_many :comments
  accepts_nested_attributes_for :comments, :allow_destroy => true
 
   # Actions using private
  before_save :save_default_values, :if => :new_record?

 
  # Method string on action show
  def str_created_at
    self.created_at.strftime("%d/%m/%Y")
  end
 
 
  # Pagination = 10
  self.per_page = 10

  private
    def save_default_values
      self.deleted = 0    
    end 
end 
