class TransformerTest < ActiveRecord::Base
  # Model relationships	
  has_many :gases
  has_many :physical_trials
 
end
