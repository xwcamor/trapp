class AddForeignKeyFactors < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :factors, :transformers
	end
end
