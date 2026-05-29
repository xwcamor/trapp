class ChromatographicalDgaDiag < ApplicationRecord
  # Model relationships
  belongs_to :transformer
 
 
  # Validate 
  private
    #def save_default_values
    #  self.deleted = 0    
    #end 
end 
