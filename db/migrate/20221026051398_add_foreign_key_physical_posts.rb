class AddForeignKeyPhysicalPosts < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :physical_posts, :transformers
	  add_foreign_key :physical_posts, :users
	  add_foreign_key :physical_posts, :physicals
	  add_foreign_key :physical_posts, :type_comments

	end
end
