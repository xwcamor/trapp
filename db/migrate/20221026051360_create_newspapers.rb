class CreateNewspapers < ActiveRecord::Migration[5.2]
  def change
    create_table :newspapers do |t|
   
      t.bigint  :user_id
      t.string  :description
      t.integer :state
      t.integer :deleted

      t.timestamps
    end
  end
end
