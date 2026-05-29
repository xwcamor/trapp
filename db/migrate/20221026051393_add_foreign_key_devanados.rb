class AddForeignKeyDevanados < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :devanados, :transformers
	end
end
