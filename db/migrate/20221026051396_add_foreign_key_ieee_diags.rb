class AddForeignKeyIeeeDiags < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :ieee_diags, :transformers
 
	end
end
