class Profile < ActiveRecord::Base

  serialize :country_id, Array
  # Model relationships
  belongs_to :country

  # Model relationships
  has_many :users
  has_many :profile_accesses
  has_many :profile_countries
 
  # Validate
  validates :name,:uniqueness => { :case_sensitive => false,:message => "Ya se encuentra en uso" }

  # Pagination = 10
 # self.per_page = 10
end
