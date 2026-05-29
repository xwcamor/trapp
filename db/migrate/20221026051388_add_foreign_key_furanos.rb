class AddForeignKeyFuranos < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :furanos, :transformers
	end
end
