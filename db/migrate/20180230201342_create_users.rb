class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string   :num_doc 
      t.string   :username 
      t.string   :name 
      t.string   :lastname1 
      t.string   :lastname2 
      t.string   :cellphone
      t.string   :email 
      t.string   :real_password 
      t.string   :hashed_password 
      t.string   :salt 
      t.bigint   :profile_id 
      t.string   :customer_id 
      t.string   :country_id 
      t.string   :password_reset_token 
      t.datetime :password_reset_token_date
      t.datetime :password_reset_change_date
      t.datetime :password_expires_after 
      t.string   :authentication_token 
      t.datetime :last_signed_in_on
      t.datetime :signed_up_on 
      t.integer  :state 
      t.integer  :deleted
    
      t.timestamps
    end
  end
end




 
