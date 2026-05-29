class AddForeignKeyDevanadoDetails < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :devanado_details, :devanados
	  add_foreign_key :devanado_details, :devanado_flows
	end
end
