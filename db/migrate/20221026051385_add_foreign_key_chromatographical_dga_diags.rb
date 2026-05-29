class AddForeignKeyChromatographicalDgaDiags < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :chromatographical_dga_diags, :transformers
	end
end
