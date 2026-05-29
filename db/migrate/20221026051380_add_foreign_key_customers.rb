class AddForeignKeyCustomers < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :customers, :countries
	end
end
