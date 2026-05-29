class AddForeignKeyCustomerLocations < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :customer_locations, :customers
	end
end
