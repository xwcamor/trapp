class AddForeignKeyChromatographicals < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :chromatographicals, :transformers
	end
end
