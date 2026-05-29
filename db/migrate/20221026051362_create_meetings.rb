class CreateMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :meetings do |t|
      t.bigint   :user_id
      t.string   :title
      t.string   :description
      t.datetime :start
      t.datetime :end
      t.string   :color
      t.integer  :deleted
      #t.text :demo, array: true, default: []
      t.timestamps
    end
  end
end
