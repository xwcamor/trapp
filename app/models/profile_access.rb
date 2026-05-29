class ProfileAccess < ActiveRecord::Base
 
  # Model relationships
  belongs_to :profile
  belongs_to :access

  # Pagination = 10
 # self.per_page = 10
end
