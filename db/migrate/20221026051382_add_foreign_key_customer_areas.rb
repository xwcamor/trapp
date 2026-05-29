class AddForeignKeyCustomerAreas < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :customer_areas, :customer_locations
	  add_foreign_key :customer_areas, :customers
	end
end
