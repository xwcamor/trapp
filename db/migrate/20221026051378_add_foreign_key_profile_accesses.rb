class AddForeignKeyProfileAccesses < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :profile_accesses, :profiles
	  add_foreign_key :profile_accesses, :accesses
	end
end
