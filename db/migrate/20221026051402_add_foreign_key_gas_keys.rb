class AddForeignKeyGasKeys < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :gas_keys, :transformers
 
	end
end
