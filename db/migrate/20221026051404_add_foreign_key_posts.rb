class AddForeignKeyPosts < ActiveRecord::Migration[7.0]
	def up 
	  add_foreign_key :posts, :transformers
      add_foreign_key :posts, :users
      add_foreign_key :posts, :chromatographicals
      add_foreign_key :posts, :type_comments 
	end
end
