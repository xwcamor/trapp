class AddForeignKeyChromatographicalDuvals < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :chromatographical_duvals, :transformers
	end
end
