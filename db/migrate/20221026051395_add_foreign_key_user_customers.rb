class AddForeignKeyUserCustomers < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :user_customers, :users
	  add_foreign_key :user_customers, :customers
	end
end
