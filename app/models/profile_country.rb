class ProfileCountry < ApplicationRecord
  # Model relationships
  belongs_to :country
  belongs_to :profile
  
end 
