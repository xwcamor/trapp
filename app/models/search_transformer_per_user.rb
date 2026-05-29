class SearchTransformerPerUser < ApplicationRecord
  
  serialize :transformer_id, Array

  belongs_to :user
  belongs_to :customer
  belongs_to :transformer
  
  validates :customer_id,:transformer_id , presence: true


end