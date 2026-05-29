class AddForeignKeyPhysicalTrials < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :physical_trials, :transformer_tests
	end
end
