class AddForeignKeyPhysicals < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :physicals, :transformers
	end
end
