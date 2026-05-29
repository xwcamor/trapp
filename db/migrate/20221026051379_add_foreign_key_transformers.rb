class AddForeignKeyTransformers < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :transformers, :customer_substations
	  add_foreign_key :transformers, :transformer_types
	  add_foreign_key :transformers, :connection_types
	  add_foreign_key :transformers, :conmutation_types
	  add_foreign_key :transformers, :transformer_preservations
	  add_foreign_key :transformers, :oil_types
	  add_foreign_key :transformers, :marks
	end
end
