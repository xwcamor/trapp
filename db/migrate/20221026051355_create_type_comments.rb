class CreateTypeComments < ActiveRecord::Migration[5.2]
  def change
    create_table :type_comments do |t|
      t.bigint   :option_post_id
      t.string   :name
      t.integer  :deleted

      t.timestamps
    end
  end
end
