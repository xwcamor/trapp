class AddForeignKeyCustomerSubstations < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :customer_substations, :customer_areas
	  add_foreign_key :customer_substations, :customers
	end
end
