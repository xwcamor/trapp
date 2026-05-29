class AddForeignKeyComments < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :comments, :posts
	  add_foreign_key :comments, :users
 
	end
end
