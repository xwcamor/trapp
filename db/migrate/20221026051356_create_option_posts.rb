class CreateOptionPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :option_posts do |t|
      t.string   :name
      t.integer  :deleted

      t.timestamps
    end
  end
end
