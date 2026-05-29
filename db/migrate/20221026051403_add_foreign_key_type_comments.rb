class AddForeignKeyTypeComments < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :type_comments, :option_posts
 
	end
end
