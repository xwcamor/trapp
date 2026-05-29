class AddForeignKeyGas < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :gas, :transformer_tests
 
	end
end
