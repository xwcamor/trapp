class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.bigint   :post_id
      t.bigint   :user_id
      t.string   :description
      t.integer  :rate 
      t.integer  :deleted

      t.timestamps
    end
  end
end
