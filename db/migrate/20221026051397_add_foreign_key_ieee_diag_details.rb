class AddForeignKeyIeeeDiagDetails < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :ieee_diag_details, :ieee_diags
	  add_foreign_key :ieee_diag_details, :chromatographicals
	end
end
