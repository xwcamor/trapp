class Access < ActiveRecord::Base

  # Validate
  validates_uniqueness_of :name, conditions: -> { where(parent_id: '0') }, :case_sensitive => false

  # Pagination = 10
  #self.per_page = 10
end
