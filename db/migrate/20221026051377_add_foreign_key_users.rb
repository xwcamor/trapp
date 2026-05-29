class AddForeignKeyUsers < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :users, :profiles
	  #add_foreign_key :users, :countries
	end
end
