class CreatePhysicalPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :physical_posts do |t|
      t.bigint   :transformer_id
      t.bigint   :user_id
      t.bigint   :physical_id
      t.bigint   :type_comment_id
      t.string   :description
      t.integer  :rate 
      t.integer  :deleted

      t.timestamps
    end
  end
end
