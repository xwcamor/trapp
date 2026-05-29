class CreateProfileAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :profile_accesses do |t|
      t.bigint :access_id
      t.bigint :profile_id
     
      t.timestamps
    end
  end
end     
