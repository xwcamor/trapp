class CreatePhysicalComments < ActiveRecord::Migration[5.2]
  def change
    create_table :physical_comments do |t|
      t.bigint   :physical_post_id
      t.bigint   :user_id
      t.string   :description
      t.integer  :rate 
      t.integer  :deleted

      t.timestamps
    end
  end
end
