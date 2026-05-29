class AddForeignKeyPhysicalComments < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :physical_comments, :physical_posts
	  add_foreign_key :physical_comments, :users
	end
end
