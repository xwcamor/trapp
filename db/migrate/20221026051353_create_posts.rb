class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.bigint   :transformer_id
      t.bigint   :user_id
      t.bigint   :chromatographical_id
      t.bigint   :type_comment_id
      t.string   :description
      t.integer  :rate 
      t.integer  :deleted

      t.timestamps
    end
  end
end
